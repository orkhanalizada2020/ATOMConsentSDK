//
//  ATOMBrazilSIMCode.m
//

#import "ATOMBrazilSIMCode.h"

@implementation ATOMBrazilSIMCode

+ (BOOL)deviceSIMCodeWithinBrazil:(NSString *_Nonnull)simCode
{
    static NSArray<NSString *> *kBrazilSIMCodes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kBrazilSIMCodes = @[ @"BR" ];
    });
    if ([kBrazilSIMCodes containsObject:simCode]) {
        return YES;
    }
    return NO;
}
@end
