//
//  ATOMBrazilTimezone.h
//

#import <Foundation/Foundation.h>

@interface ATOMBrazilTimezone: NSObject

/**
 Method checks the local timezone to determine if the user device is in Brazil.
 returns YES if within Brazil. If not, returns NO.

 @param timezone    Local timezone of the device.
 @return          \c BOOL if timezone belongs to Brazil, return YES else NO.
 */
+ (BOOL)deviceTimezoneInBrazil:(NSTimeZone *_Nonnull)timezone;

@end
