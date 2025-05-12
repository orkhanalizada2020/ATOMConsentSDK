//
//  ATOMSystemInfo.m
//

#import "ATOMSystemInfo.h"
#import "ATOMAppTransportSecuritySettings.h"

static ATOMAppTransportSecuritySettings *sAppTransportSecuritySetting = nil;

NSString *ATOMAdConnectionTypeToApiValue(ATOMConnectionStatus connectionStatus)
{
    switch (connectionStatus) {
        case kATOMConnectionStatusUnknown:
        case kATOMConnectionStatusNotReachable:
        case kATOMConnectionStatusReachableViaEthernet:
            return nil;

        case kATOMConnectionStatusReachableViaWiFi:
            return @"WiFi";

        case kATOMConnectionStatusReachableViaCellularNetworkUnknownGeneration:
            return @"UNKNOWN";

        case kATOMConnectionStatusReachableViaCellularNetwork2G:
            return @"2G";

        case kATOMConnectionStatusReachableViaCellularNetwork3G:
            return @"3G";

        case kATOMConnectionStatusReachableViaCellularNetwork4G:
            return @"4G";
    }

    return nil;
}

@implementation ATOMSystemInfo

#pragma mark - <ATOMSystemInfoProtocol>

+ (ATOMAppTransportSecuritySettings *)appTransportSecuritySetting
{
    if (!sAppTransportSecuritySetting) {
        sAppTransportSecuritySetting = [[ATOMAppTransportSecuritySettings alloc] init];
    }

    return sAppTransportSecuritySetting;
}

@end
