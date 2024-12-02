//
//  ATOMSystemInformationProvider.m
//

#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/utsname.h>
#import <UIKit/UIKit.h>

#import "ATOMSystemInformationProvider.h"

static ATOMSystemInformationProvider *sSharedProvider = nil;

static NSString *const kATOMSKAdNetworkItemKey = @"SKAdNetworkItems";
static NSString *const kATOMSKAdNetworkItemIdentifierKey = @"SKAdNetworkIdentifier";

@interface ATOMSystemInformationProvider ()

@property (nonatomic) CTTelephonyNetworkInfo *mobileNetworkInfo;

- (NSString *)deviceCarrierCodeFromCellularCarrier:(CTCarrier *)carrier;
- (NSString *)deviceisoCountryCodeFromCellularCarrier:(CTCarrier *)carrier;
- (NSString *)deviceMobileCountryCodeFromCellularCarrier:(CTCarrier *)carrier;

@end

@implementation ATOMSystemInformationProvider

+ (instancetype)sharedProvider
{
    ATOMSystemInformationProvider *provider = nil;

    @synchronized(self) {
        if (!sSharedProvider) {
            sSharedProvider = [[ATOMSystemInformationProvider alloc] init];
        }

        provider = sSharedProvider;
    }

    return provider;
}

+ (void)stopProvider
{
    @synchronized(self) {
        sSharedProvider = nil;
    }
}

- (NSString *)isoCountryCode
{
    return [self deviceisoCountryCodeFromCellularCarrier:self.mobileNetworkInfo.subscriberCellularProvider];
}

- (instancetype)init
{
    self = [super init];

    if (self) {
        self.mobileNetworkInfo = [CTTelephonyNetworkInfo new];
    }

    return self;
}

#pragma mark - Private Interface

- (NSString *)deviceCarrierCodeFromCellularCarrier:(CTCarrier *)carrier
{
    if (!carrier) {
        return nil;
    }

    NSString *carrierCode = nil;

    if (carrier.mobileCountryCode.length > 0 && carrier.mobileNetworkCode.length > 0) {
        carrierCode = [NSString stringWithFormat:@"%@%@", carrier.mobileCountryCode, carrier.mobileNetworkCode];
    }

    return carrierCode;
}

- (NSString *)deviceisoCountryCodeFromCellularCarrier:(CTCarrier *)carrier
{
    if (!carrier) {
        return nil;
    }

    NSString *isoCountryCode = nil;

    if (carrier.isoCountryCode.length > 0) {
        isoCountryCode = [carrier.isoCountryCode uppercaseString];
    }

    return isoCountryCode;
}

- (NSString *)deviceMobileCountryCodeFromCellularCarrier:(CTCarrier *)carrier
{
    if (!carrier) {
        return nil;
    }

    NSString *mobileCountryCode = nil;

    if (carrier.mobileCountryCode.length > 0) {
        mobileCountryCode = carrier.mobileCountryCode;
    }

    return mobileCountryCode;
}

- (NSString *)deviceModel
{
    static NSString *deviceModel = nil;

    if (!deviceModel) {
        struct utsname systemInfo;
        uname(&systemInfo);

        deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    }

    return deviceModel;
}

@end
