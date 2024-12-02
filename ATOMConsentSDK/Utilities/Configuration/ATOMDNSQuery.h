//
//  ATOMDNSQuery.h
//

#import <Foundation/Foundation.h>

@protocol ATOMDNSQuerying

- (void)txtRecordWithCompletionBlock:(void (^)(NSString *result))completionBlock;

@end

@protocol ATOMDNSQueryingExt

- (void)entryForKey:(NSString *)key withCompletionBlock:(void (^)(NSString *result))completionBlock;

@end

@interface ATOMDNSQuery: NSObject <ATOMDNSQuerying, ATOMDNSQueryingExt>

- (instancetype)initWithDomainName:(NSString *)domainName;

@end
