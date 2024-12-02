//
//  ATOMSystemInfo.h
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

/// Network connection status values that are compliant with IAB spec
typedef NS_ENUM(NSInteger, ATOMConnectionStatus) {
    kATOMConnectionStatusUnknown = -1,
    kATOMConnectionStatusNotReachable = 0,
    kATOMConnectionStatusReachableViaEthernet = 1, /* unused as currently iOS devices, unlike Android ones, don't allow ethernet dongles */
    kATOMConnectionStatusReachableViaWiFi = 2,
    kATOMConnectionStatusReachableViaCellularNetworkUnknownGeneration = 3,
    kATOMConnectionStatusReachableViaCellularNetwork2G = 4,
    kATOMConnectionStatusReachableViaCellularNetwork3G = 5,
    kATOMConnectionStatusReachableViaCellularNetwork4G = 6,
};

typedef NS_ENUM(NSInteger, ATOMDeviceHardwareType) {
    kATOMDeviceHardwareUnknown = -1,
    kATOMDeviceHardwareIPhone = 0,
    kATOMDeviceHardwareIPod = 1,
    kATOMDeviceHardwareIPad = 2,
    kATOMDeviceHardwareSimulator = 3,
};

/**
 Helper method to map `connectionStatus` to any of defined API values.

 @param connectionStatus network connection status
 @return NSString value
 */
NSString *_Nullable ATOMAdConnectionTypeToApiValue(ATOMConnectionStatus connectionStatus);

@class ATOMAppTransportSecuritySettings;
@class ATOMLocation;

@protocol ATOMSystemInfoProtocol <NSObject>
@required
- (BOOL)isAdvertisingTrackingEnabled;
- (nullable NSString *)advertisingIdentifier;
- (ATOMConnectionStatus)deviceConnectionType;
- (nullable NSString *)deviceCarrierCode;
- (nullable NSString *)isoCountryCode;
- (nullable NSString *)mobileCountryCode;
- (nullable NSString *)carrierName;
- (ATOMDeviceHardwareType)deviceHardwareType;
- (nullable NSString *)devicePlatform;
- (nullable NSString *)deviceVendor;
- (nullable NSString *)deviceOSVersion;
- (nullable NSString *)deviceLocale;
- (CGSize)deviceScreenSize;
- (CGFloat)devicePixelScale;
- (nullable NSString *)deviceModel;
- (nullable NSString *)deviceIpAddress;
- (nullable NSString *)applicationId;
- (nullable ATOMLocation *)location;
- (nullable NSString *)clientSdkVersion;
- (nullable NSString *)fcid;
- (nullable NSString *)userAgent;
- (NSInteger)utcOffset;
- (nullable NSArray<NSString *> *)viewabilityPlugins;
+ (nonnull ATOMAppTransportSecuritySettings *)appTransportSecuritySetting;
- (nullable NSArray<NSString *> *)skAdNetworkItems;
- (nullable NSString *)skAdNetworkVersion;
- (nullable NSString *)unityVersion;
- (nullable NSString *)idfv;
- (NSInteger)ATTrackingAuthStatus;

@end

@interface ATOMSystemInfo: NSObject <ATOMSystemInfoProtocol>

@property (nonatomic, getter=isAdvertisingTrackingEnabled) BOOL advertisingTrackingEnabled;
@property (nonatomic, nullable, copy) NSString *advertisingIdentifier;
@property (nonatomic) ATOMConnectionStatus deviceConnectionType;
@property (nonatomic, nullable, copy) NSString *deviceCarrierCode;
@property (nonatomic, nullable, copy) NSString *isoCountryCode;
@property (nonatomic, nullable, copy) NSString *mobileCountryCode;
@property (nonatomic, nullable, copy) NSString *carrierName;
@property (nonatomic) ATOMDeviceHardwareType deviceHardwareType;
@property (nonatomic, nullable, copy) NSString *devicePlatform;
@property (nonatomic, nullable, copy) NSString *deviceVendor;
@property (nonatomic, nullable, copy) NSString *deviceOSVersion;
@property (nonatomic, nullable, copy) NSString *deviceLocale;
@property (nonatomic) CGSize deviceScreenSize;
@property (nonatomic) CGFloat devicePixelScale;
@property (nonatomic, nullable, copy) NSString *deviceModel;
@property (nonatomic, nullable, copy) NSString *deviceIpAddress;
@property (nonatomic, nullable, copy) NSString *applicationId;
@property (nonatomic, nullable, copy) ATOMLocation *location;
@property (nonatomic, nonnull, copy) NSString *clientSdkVersion;
@property (nonatomic, nullable, copy) NSString *unityVersion;
@property (nonatomic, nonnull, copy) NSString *fcid;
@property (nonatomic, nonnull, copy) NSString *userAgent;
@property (nonatomic) NSInteger utcOffset;
@property (class, nonatomic, nonnull, readonly) ATOMAppTransportSecuritySettings *appTransportSecuritySetting;
@property (nonatomic, nullable, copy) NSArray<NSString *> *viewabilityPlugins;
@property (nonatomic, nullable, copy) NSArray<NSString *> *skAdNetworkItems;
@property (nonatomic, nullable, copy) NSString *skAdNetworkVersion;
@property (nonatomic) NSInteger ATTrackingAuthStatus;
@property (nonatomic, nullable, copy) NSString *idfv;

@end
