//
//  ATOMATSException.h
//

#import <Foundation/Foundation.h>

/**
 Holds information about domains that are __exempt__ from ATS and are allowed to do arbitraty loads with HTTP.
 Additionally tells if subdomains of the passed \c domain are exempt as well.

 @note ATS has another kind of exception: when `NSAllowsArbitraryLoads` is set to YES (and is not ignored due to iOS 10+ behavior),
       and `NSExceptionDomains` entry has `NSExceptionAllowsInsecureHTTPLoads` has set to NO, this means the domain is not allowed
       to do arbitrary loads using HTTP. Such kind of exception is aimed at increasing security and as cannot be expressed by this class.
 */
@interface ATOMATSException: NSObject

@property (nonatomic, readonly, copy) NSString *domain;
@property (nonatomic, readonly) BOOL includesSubdomains;

- (instancetype)init NS_UNAVAILABLE;

/**
 Class factory method for creating ATS exceptions instances.

 @param domain              domain that is allowed to do arbitrary loads using HTTP; cannot be \c nil
 @param includesSubdomains  if YES, subdomains of passed \c domain are allowed to do HTTP; NO otherwise
 @return                    ATS exception instance or \c nil if passed \c domain is \c nil
 */
+ (instancetype)atsExceptionWithDomain:(NSString *)domain includesSubdomains:(BOOL)includesSubdomains;

/**
 Helper method that tests whether a passed \c subdomain is a subdomain of \c self.domain when \c includesSubdomains is true.

 @note There is one special case, when \c includesSubdomains is false, but the passed \c subdomain is equal to \c domain - YES is returned.

 @param subdomain domain to check if it is a subdomain of \c domain
 @return YES if \c subdomain is a subdomain of \c domain; NO otherwise
 */
- (BOOL)isSubdomainExemptFromAtsSettings:(NSString *)subdomain;

@end
