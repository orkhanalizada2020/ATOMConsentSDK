//
//  ATOMATSException.m
//

#import "ATOMATSException.h"

@interface ATOMATSException ()

@property (nonatomic, readwrite, copy) NSString *domain;
@property (nonatomic, readwrite) BOOL includesSubdomains;

@end

@implementation ATOMATSException

+ (instancetype)atsExceptionWithDomain:(NSString *)domain includesSubdomains:(BOOL)includesSubdomains
{
    if (domain.length == 0) {
        return nil;
    }

    ATOMATSException *exception = [ATOMATSException new];

    exception.domain = domain;
    exception.includesSubdomains = includesSubdomains;

    return exception;
}

- (BOOL)isSubdomainExemptFromAtsSettings:(NSString *)subdomain
{
    if ([subdomain.lowercaseString isEqualToString:self.domain]) {
        return YES;
    }

    if (!self.includesSubdomains) {
        return NO;
    }

    return [subdomain.lowercaseString hasSuffix:self.domain];
}

@end
