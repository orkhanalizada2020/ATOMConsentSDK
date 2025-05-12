//
//  ATOMAppTransportSecuritySettings.m
//

#import "ATOMAppTransportSecuritySettings.h"
#import "ATOMATSException.h"

static ATOMATSSetting ATOMAtsSetting = kATOMATSSettingEnabled;    // assume ATS is enabled
static NSSet<ATOMATSException *> *ATOMAtsExceptionDomains = nil;

@interface ATOMAppTransportSecuritySettings ()

- (ATOMATSSetting)atsSettingFromAtsDictionaryOniOS10AndLater:(NSDictionary<NSString *, id> *)atsDictionary;
- (ATOMATSSetting)atsSettingFromAtsDictionaryOniOS9:(NSDictionary<NSString *, id> *)atsDictionary;
- (ATOMATSSetting)atsSettingOniOS8;

@end

@implementation ATOMAppTransportSecuritySettings

- (ATOMATSSetting)atsSetting
{
    static dispatch_once_t sOnceToken = 0;

    // ATS settings cannot change during lifecycle of application's process, therefore it is enough to set ATS settings once
    dispatch_once(&sOnceToken, ^(void) {
        NSDictionary<NSString *, id> *atsDictionary = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSAppTransportSecurity"];

        if (@available(iOS 10.0, *)) {
            ATOMAtsSetting = [self atsSettingFromAtsDictionaryOniOS10AndLater:atsDictionary];
        } else if (@available(iOS 9.0, *)) {
            ATOMAtsSetting = [self atsSettingFromAtsDictionaryOniOS9:atsDictionary];
        } else if (@available(iOS 8.0, *)) {
            ATOMAtsSetting = [self atsSettingOniOS8];
        }
        // else should not happen
    });

    return ATOMAtsSetting;
}

- (NSSet<ATOMATSException *> *)atsExceptionDomains
{
    // ATS settings cannot change during lifecycle of application's process, therefore it is enough to set ATS settings once
    if (!ATOMAtsExceptionDomains) {
        if (@available(iOS 9.0, *)) {
            NSDictionary<NSString *, id> *atsSettings = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSAppTransportSecurity"];
            NSDictionary<NSString *, NSDictionary *> *exceptionsRegistry = atsSettings[@"NSExceptionDomains"];
            NSMutableSet<ATOMATSException *> *exceptions = [NSMutableSet set];

            [exceptionsRegistry
            enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSDictionary *_Nonnull obj, BOOL *_Nonnull stop) {
                if ([obj[@"NSExceptionAllowsInsecureHTTPLoads"] boolValue]) {
                    ATOMATSException *exception =
                    [ATOMATSException atsExceptionWithDomain:key includesSubdomains:[obj[@"NSIncludesSubdomains"] boolValue]];
                    [exceptions addObject:exception];
                }
            }];

            ATOMAtsExceptionDomains = [exceptions copy];
        } else {
            ATOMAtsExceptionDomains = [NSSet set];
        }
    }

    return ATOMAtsExceptionDomains;
}

- (BOOL)isAtsDisabled
{
    return ((self.atsSetting & kATOMATSSettingAllowsArbitraryLoads) == kATOMATSSettingAllowsArbitraryLoads);
}

- (BOOL)isDomainExemptFromAtsSettings:(NSString *)domain
{
    if (self.isAtsDisabled) {
        return YES;
    }

    if (domain.length == 0) {
        return NO;
    }

    __block BOOL isExempt = NO;

    // 1. Find if passed `domain` equals to any of domains in exceptions
    NSSet<NSString *> *domains = [self.atsExceptionDomains valueForKeyPath:@"domain"];
    isExempt = [domains containsObject:domain.lowercaseString];

    // 2. If 1st check failed, for exceptions with `includesSubdomains` set,
    //    check if the passed `domain` has a suffix with exception's domain
    if (!isExempt) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"includesSubdomains == YES"];
        NSSet<ATOMATSException *> *exceptionsWithSubdomains = [self.atsExceptionDomains filteredSetUsingPredicate:predicate];

        domains = [exceptionsWithSubdomains valueForKeyPath:@"domain"];

        [domains enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, BOOL *_Nonnull stop) {
            if ([domain.lowercaseString hasSuffix:obj]) {
                isExempt = YES;
                *stop = YES;
            }
        }];
    }

    return isExempt;
}

- (BOOL)isUrlExemptFromAtsSettings:(NSURL *)url
{
    if (!url || self.isAtsDisabled) {
        return YES;
    }

    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    if (!components || !components.scheme) {
        return NO;
    }

    return [self isDomainExemptFromAtsSettings:components.host];
}

#pragma mark - Private Interface

- (ATOMATSSetting)atsSettingFromAtsDictionaryOniOS10AndLater:(NSDictionary<NSString *, id> *)atsDictionary
{
    /**
     iOS 10 extends ATS settings and `NSAllowsArbitraryLoads` flag becomes ignored in favor of three new, fine-grained settings:
     - NSAllowsArbitraryLoadsForMedia
     - NSAllowsArbitraryLoadsInWebContent
     - NSAllowsLocalNetworking

     If all three are set to YES, it does not mean `NSAllowsArbitraryLoads` is respected nor that arbitrary loads are allowed.
     To fully determine this, it is required to consult `NSExceptionDomains` from a proper perspective of `NSAllowsArbitraryLoads`
     setting, and
     */

    if (!atsDictionary || atsDictionary.count == 0) {
        return kATOMATSSettingEnabled;
    }

    ATOMATSSetting atsSetting = kATOMATSSettingEnabled;

    // If none of iOS 10 specific flags are present, we can fall back to NSAllowsArbitraryLoads
    if (!atsDictionary[@"NSAllowsArbitraryLoadsForMedia"] && !atsDictionary[@"NSAllowsArbitraryLoadsInWebContent"] &&
        !atsDictionary[@"NSAllowsLocalNetworking"]) {
        if (atsDictionary && [atsDictionary[@"NSAllowsArbitraryLoads"] boolValue]) {
            atsSetting = kATOMATSSettingAllowsArbitraryLoads;
        } else {
            atsSetting = kATOMATSSettingEnabled;
        }
    } else {
        // default values are NO, so `-boolValue` on `nil` is ok here
        BOOL allowsLoadsForMedia = [atsDictionary[@"NSAllowsArbitraryLoadsForMedia"] boolValue];
        BOOL allowsLoadsInWebContent = [atsDictionary[@"NSAllowsArbitraryLoadsInWebContent"] boolValue];
        BOOL allowsLocalNetworking = [atsDictionary[@"NSAllowsLocalNetworking"] boolValue];

        if (!allowsLoadsForMedia && !allowsLoadsInWebContent && !allowsLocalNetworking) {
            // if no options are present or all are set to NO, ATS is enabled on iOS 10+
            atsSetting = kATOMATSSettingEnabled;
        } else {
            // set value based on available options
            if (allowsLoadsForMedia) {
                atsSetting |= kATOMATSSettingAllowsArbitraryLoadsForMedia;
            }
            if (allowsLoadsInWebContent) {
                atsSetting |= kATOMATSSettingAllowsArbitraryLoadsInWebContent;
            }
            if (allowsLocalNetworking) {
                atsSetting |= kATOMATSSettingAllowsLocalNetworking;
            }

            // if above flags allow arbitrary loads, it doesn't mean ATS is disabled (even if `NSAllowsArbitraryLoads` is YES);
            // in such cases, `NSExceptionDomains` needs to be consulted, but it carries another twist in the plot:
            //
            //   exception can be in two directions: 1) allowing HTTP for a given domain
            //                                       2) disallowing HTTP for a given domain if `NSAllowsArbitraryLoads` is YES
        }
    }

    return atsSetting;
}

- (ATOMATSSetting)atsSettingFromAtsDictionaryOniOS9:(NSDictionary<NSString *, id> *)atsDictionary
{
    // iOS 9 introduced ATS and its settings are expressed using single entry without fine-grained control for media etc.
    // however, if ATS is enabled, the exception domains should be checked

    if (!atsDictionary || atsDictionary.count == 0) {
        return kATOMATSSettingEnabled;
    }

    ATOMATSSetting atsSetting = kATOMATSSettingEnabled;

    if ([atsDictionary[@"NSAllowsArbitraryLoads"] boolValue]) {
        atsSetting = kATOMATSSettingAllowsArbitraryLoads;
    }

    return atsSetting;
}

- (ATOMATSSetting)atsSettingOniOS8
{
    // iOS 8 had no concept of ATS, therefore arbitraty loads are always allowed
    return kATOMATSSettingAllowsArbitraryLoads;
}

@end
