//
//  ATOMEuropeTimezone.h
//

#import <Foundation/Foundation.h>

@interface ATOMEuropeTimezone: NSObject

/**
 Method checks the local timezone to determine if the user device is in EEA.
 returns YES if within EEA. If not, returns NO.

 @param timezone    Local timezone of the device.
 @return          \c BOOL if timezone belongs to EEA, return YES else NO.
 */
+ (BOOL)deviceTimezoneInEEA:(NSTimeZone *_Nonnull)timezone;

@end
