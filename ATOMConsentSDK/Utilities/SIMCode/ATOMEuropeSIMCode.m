//
//  ATOMEuropeSIMCode.m
//

#import "ATOMEuropeSIMCode.h"

@implementation ATOMEuropeSIMCode

+ (BOOL)deviceSIMCodeWithinEEA:(NSString *_Nonnull)simCode
{
    static NSArray<NSString *> *kEuropeanSIMCodes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kEuropeanSIMCodes = @[
            @"AT",
            @"BE",
            @"BG",
            @"HR",
            @"CY",
            @"CZ",
            @"DK",
            @"EE",
            @"FI",
            @"FR",
            @"DE",
            @"GR",
            @"HU",
            @"IE",
            @"IT",
            @"LV",
            @"LT",
            @"LU",
            @"MT",
            @"NL",
            @"PL",
            @"PT",
            @"RO",
            @"SK",
            @"SI",
            @"ES",
            @"SE",
            @"IS",
            @"LI",
            @"NO",
            @"GB"
        ];
    });
    if ([kEuropeanSIMCodes containsObject:simCode]) {
        return YES;
    }
    return NO;
}
@end
