//
//  ATOMEuropeTimezone.m
//

#import "ATOMEuropeTimezone.h"

@implementation ATOMEuropeTimezone

+ (BOOL)deviceTimezoneInEEA:(NSTimeZone *_Nonnull)timezone
{
    static NSArray<NSString *> *kEuropeanTimezones;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kEuropeanTimezones = @[
            @"Atlantic/Reykjavik",
            @"Europe/Amsterdam",
            @"Europe/Andorra",
            @"Europe/Astrakhan",
            @"Europe/Athens",
            @"Europe/Belgrade",
            @"Europe/Berlin",
            @"Europe/Bratislava",
            @"Europe/Brussels",
            @"Europe/Bucharest",
            @"Europe/Budapest",
            @"Europe/Busingen",
            @"Europe/Chisinau",
            @"Europe/Copenhagen",
            @"Europe/Dublin",
            @"Europe/Gibraltar",
            @"Europe/Guernsey",
            @"Europe/Helsinki",
            @"Europe/Isle_of_Man",
            @"Europe/Istanbul",
            @"Europe/Jersey",
            @"Europe/Kaliningrad",
            @"Europe/Kiev",
            @"Europe/Kirov",
            @"Europe/Lisbon",
            @"Europe/Ljubljana",
            @"Europe/London",
            @"Europe/Luxembourg",
            @"Europe/Madrid",
            @"Europe/Malta",
            @"Europe/Mariehamn",
            @"Europe/Minsk",
            @"Europe/Monaco",
            @"Europe/Moscow",
            @"Europe/Oslo",
            @"Europe/Paris",
            @"Europe/Podgorica",
            @"Europe/Prague",
            @"Europe/Riga",
            @"Europe/Rome",
            @"Europe/Samara",
            @"Europe/San_Marino",
            @"Europe/Sarajevo",
            @"Europe/Saratov",
            @"Europe/Simferopol",
            @"Europe/Skopje",
            @"Europe/Sofia",
            @"Europe/Stockholm",
            @"Europe/Tallinn",
            @"Europe/Tirane",
            @"Europe/Ulyanovsk",
            @"Europe/Uzhgorod",
            @"Europe/Vaduz",
            @"Europe/Vatican",
            @"Europe/Vienna",
            @"Europe/Vilnius",
            @"Europe/Volgograd",
            @"Europe/Warsaw",
            @"Europe/Zagreb",
            @"Europe/Zaporozhye",
            @"Europe/Zurich"
        ];
    });
    if ([kEuropeanTimezones containsObject:timezone.name]) {
        return YES;
    }
    return NO;
}

@end
