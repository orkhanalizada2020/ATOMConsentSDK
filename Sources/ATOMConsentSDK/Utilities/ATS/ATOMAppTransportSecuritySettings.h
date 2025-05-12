//
//  ATOMAppTransportSecuritySettings.h
//

#import <Foundation/Foundation.h>

/**
 Option type partially modeling Application Transport Security settings - \c NSExceptionDomains are ignored.
 Modeling is partial because SOMA API is HTTPS only, therefore it wouldn't make sense for publishers to put SOMA API URL into exceptions;
 and other exceptions, as provided by publishers in Info.plist, are not relevant to neither SOMA API nor 3rd-party traffic of becaons as
 these domains are most likely known by publishers.

 @see See also implementation of \c appTransportSecuritySetting for details related to specific iOS version behavior.
 */
typedef NS_OPTIONS(NSUInteger, ATOMATSSetting) {
    /**
     ATS restrictions are enabled for all network connections, apart from the connections to domains configured individually
     in the optional `NSExceptionDomains` dictionary. Available from iOS 9, but __ignored__ on iOS 10 and later
     */
    kATOMATSSettingEnabled = 0,

    /**
     ATS restrictions are disabled for all network connections, apart from the connections to domains configured individually
     in the optional `NSExceptionDomains` dictionary. Available from iOS 9
     */
    kATOMATSSettingAllowsArbitraryLoads = (1 << 0),

    /**
     ATS restrictions are disabled for already encrypted media (FairPlay/HLS) which do not contain personal information.
     Media needs to be loaded using the AV Foundation framework. Available from iOS 10
     */
    kATOMATSSettingAllowsArbitraryLoadsForMedia = (1 << 1),

    /**
     ATS restrictions are disabled for requests made from web views including embeded browsers. Available from iOS 10
     */
    kATOMATSSettingAllowsArbitraryLoadsInWebContent = (1 << 2),

    /**
     Allows loading of local resources without disabling ATS for the rest of app. Available from iOS 10
     */
    kATOMATSSettingAllowsLocalNetworking = (1 << 3),
};

@class ATOMATSException;

/**
 Stores application's Application Transport Security Settings (ATS)
 Based on: https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html
 */
@interface ATOMAppTransportSecuritySettings: NSObject

@property (nonatomic, readonly) ATOMATSSetting atsSetting;
@property (nonatomic, readonly) NSSet<ATOMATSException *> *atsExceptionDomains;
@property (nonatomic, readonly, getter=isAtsDisabled) BOOL isAtsDisabled;

/**
 Tells whether passed \c domain is exempt from ATS and is allowed to do arbitrary loads using HTTP.

 @param domain  domain to check for ATS exemption (can be a subdomain)
 @return        YES - domain can do HTTP requests; otherwise NO
 */
- (BOOL)isDomainExemptFromAtsSettings:(NSString *)domain;

/**
 Tells whether passed \c URL's domain is exempt from ATS and is allowed to do arbitrary loads using HTTP.

 @param url     URL to check for ATS exemption
 @return        YES - URL's domain can do HTTP requests; otherwise NO
 */
- (BOOL)isUrlExemptFromAtsSettings:(NSURL *)url;

@end
