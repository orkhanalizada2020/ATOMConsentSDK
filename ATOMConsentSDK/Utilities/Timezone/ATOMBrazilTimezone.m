//
//  ATOMBrazilTimezone.m
//

#import "ATOMBrazilTimezone.h"

@implementation ATOMBrazilTimezone

+ (BOOL)deviceTimezoneInBrazil:(NSTimeZone *_Nonnull)timezone
{
    static NSArray<NSString *> *kBrazilTimezones;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kBrazilTimezones = @[
            @"America/Fortaleza",
            @"America/Sao_Paulo",
            @"America/Porto_Velho",
            @"America/Eirunepe",
            @"America/Rio_Branco",
            @"America/Boa_Vista",
            @"America/Campo_Grande",
            @"America/Cuiaba",
            @"America/Manaus",
            @"America/Araguaina",
            @"America/Bahia",
            @"America/Belem",
            @"America/Maceio",
            @"America/Recife",
            @"America/Santarem",
            @"America/Noronha",
            @"Brazil/Acre",
            @"Brazil/East",
            @"Brazil/West",
        ];
    });
    if ([kBrazilTimezones containsObject:timezone.name]) {
        return YES;
    }
    return NO;
}

// for mocking in unit tests...
- (BOOL)deviceTimezoneInBrazil:(NSTimeZone *_Nonnull)timezone
{
    return [self.class deviceTimezoneInBrazil:timezone];
}

@end
