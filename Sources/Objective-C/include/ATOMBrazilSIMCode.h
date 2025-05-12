//
//  ATOMBrazilSIMCode.h
//

#import <Foundation/Foundation.h>

@interface ATOMBrazilSIMCode: NSObject

/**
 Method checks the SIM code to determine if the user device is in Brazil.
 returns YES if within Brazil. If not, returns NO.
 SIM country codes are in ISO 3166-1 format.
 For more information https://en.wikipedia.org/wiki/ISO_3166-1

 @param simCode             Device SIM code.
 @return             \c BOOL if SIM code belongs to Brazil, returns YES else NO.
 */
+ (BOOL)deviceSIMCodeWithinBrazil:(NSString *_Nonnull)simCode;

@end
