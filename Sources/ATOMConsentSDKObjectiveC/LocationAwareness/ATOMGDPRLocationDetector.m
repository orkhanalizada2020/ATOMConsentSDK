//
//  ATOMGDPRLocationDetector.m
//

#import "ATOMGDPRLocationDetector.h"
#import "ATOMSystemInformationProvider.h"
#import "ATOMEuropeTimezone.h"
#import "ATOMEuropeSIMCode.h"
#import "ATOMDNSQuery.h"
#import "ATOMEndpoints.h"

@implementation ATOMGDPRLocationDetector

+ (BOOL)isSubjectToLocationAware
{
    BOOL flag = NO;
    
    if ([self hasDeviceHaveSIM]) {
        flag = [self checkFromSIMNetwork];
    }
    
    if (!flag) {
        flag = [self checkFromTimeZone];
    }
    
    if (!flag) {
        flag = [self checkFromDNSRecord];
    }
    
    return flag;
}

#pragma mark - Flag Modifiers

+ (BOOL)checkFromSIMNetwork
{
    NSString *simCountryCode = [self getSIMCountryCode];
    return [self isSIMNetworkGDPR:simCountryCode];
}

+ (BOOL)checkFromTimeZone
{
    NSTimeZone *timeZone = [self getTimeZone];
    return [self isTimeZoneGDPR:timeZone];
}

+ (BOOL)checkFromDNSRecord
{
    NSString *geoclueURL = kATOMGeoClueURL;
    ATOMDNSQuery *dnsQuery = [[ATOMDNSQuery alloc] initWithDomainName:geoclueURL];
    return [self checkFromDNSRecordWithQuery:dnsQuery];
}

+ (BOOL)isSIMNetworkGDPR:(NSString *)isoCountryCode
{
    return [ATOMEuropeSIMCode deviceSIMCodeWithinEEA:isoCountryCode];
}

+ (BOOL)isTimeZoneGDPR:(NSTimeZone *)timeZone
{
    return [ATOMEuropeTimezone deviceTimezoneInEEA:timeZone];
}

+ (BOOL)checkFromDNSRecordWithQuery:(ATOMDNSQuery *)dnsQuery
{
    __block BOOL flag = NO;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self isDNSRecordGDPRWithQuery:dnsQuery andCompletion:^(BOOL isGDPR) {
        flag = isGDPR;
        dispatch_semaphore_signal(semaphore);
    } andFailure:^{
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)));
    
    return flag;
}

+ (void)isDNSRecordGDPRWithQuery:(ATOMDNSQuery *)dnsQuery andCompletion:(void (^)(BOOL isGDPR))completion andFailure:(void (^)(void))failure
{
    [self getDNSRecordWithQuery:dnsQuery
                  andCompletion:^(NSString *result) {
        completion([result isEqualToString:@"GDPR"]);
    }
                     andFailure:failure];
}

#pragma mark - Data Fetchers

+ (BOOL)hasDeviceHaveSIM
{
    return ([self getSIMCountryCode].length > 0);
}

// ISO 3166-1 alpha-2 standard
+ (NSString *)getSIMCountryCode
{
    return [ATOMSystemInformationProvider.sharedProvider isoCountryCode];
}

+ (NSTimeZone *)getTimeZone
{
    return [NSTimeZone systemTimeZone];
}

+ (void)getDNSRecordWithQuery:(ATOMDNSQuery *)dnsQuery
                andCompletion:(void (^)(NSString *result))completion
                   andFailure:(void (^)(void))failure
{
    // DNS Query TXT record
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [dnsQuery txtRecordWithCompletionBlock:^(NSString *result) {
            if (!result) {
                failure();
            }
            
            if ([result rangeOfString:@"policy:"].location != NSNotFound) {
                completion([result stringByReplacingOccurrencesOfString:@"policy:" withString:@""]);
            }
        }];
    });
}

@end
