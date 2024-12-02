//
//  ATOMSystemInformationProvider.h
//

#import <Foundation/Foundation.h>
#import "ATOMSystemInfo.h"

typedef NS_ENUM(NSUInteger, ATOMLocationSourceType) {
    kATOMLocationNoData = 0,    // our internal default flag
    kATOMLocationSourceGPS = 1,
    kATOMLocationSourceIP = 2,
    kATOMLocationSourceUserProvided = 3
};

@interface ATOMSystemInformationProvider: NSObject

/**
 @return Shared \c ATOMSystemInformationProvider instance.
 */
+ (instancetype)sharedProvider;

- (NSString *)isoCountryCode;

@end

/// To be used in unit-test environment only.
@interface ATOMSystemInformationProvider (Tests)

/// Sets backing static storage to \c nil.
+ (void)stopProvider;

@end
