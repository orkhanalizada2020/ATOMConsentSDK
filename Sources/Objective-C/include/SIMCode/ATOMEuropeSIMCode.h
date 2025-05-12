//
//  ATOMEuropeSIMCode.h
//

#import <Foundation/Foundation.h>

@interface ATOMEuropeSIMCode: NSObject

/**
 Method checks the SIM code to determine if the user device is in EEA.
 returns YES if within EEA. If not, returns NO.
 SIM country codes are in ISO 3166-1 format.
 For more information https://en.wikipedia.org/wiki/ISO_3166-1

 @param simCode             Device SIM code.
 @return             \c BOOL if SIM code belongs to EEA, returns YES else NO.
 */
+ (BOOL)deviceSIMCodeWithinEEA:(NSString *_Nonnull)simCode;

@end
