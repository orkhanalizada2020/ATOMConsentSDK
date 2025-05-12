//
//  ATOMDNSQuery.m
//

#import "ATOMDNSQuery.h"

#import <dns_sd.h>

static NSString *const kDNSVersionKey = @"v=1";
static NSString *const kDNStimestamp = @"timestamp";

@interface ATOMDNSQuery ()

@property (nonatomic, copy) NSString *domainName;
@property (nonatomic, copy) NSString *entryKey;
@property (nonatomic) uint16_t serviceType;
@property (nonatomic) uint16_t serviceClass;
@property (nonatomic, copy) void (^completionBlock)(NSString *);

@property (nonatomic, copy) NSString *mockresponse;

@end

@implementation ATOMDNSQuery

- (instancetype)initWithDomainName:(NSString *)domainName
{
    self = [super init];
    
    if (self) {
        self.domainName = domainName;
    }
    
    return self;
}

#pragma mark - Public methods

- (void)fetchDNSResult
{
    //    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        //        @strongify(self);
        
        if (self.mockresponse) {
            [self receivedData:[self.mockresponse dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        DNSServiceRef serviceRef;
        DNSServiceErrorType err = DNSServiceQueryRecord(&serviceRef,
                                                        kDNSServiceFlagsReturnIntermediates,
                                                        0,
                                                        [self.domainName UTF8String],
                                                        kDNSServiceType_TXT,
                                                        kDNSServiceClass_IN,
                                                        queryCallback,
                                                        (__bridge void *)self);
        
        if (err == kDNSServiceErr_NoError) {
            DNSServiceProcessResult(serviceRef);
        } else {
            [self failed:err];
        }
        
        DNSServiceRefDeallocate(serviceRef);
    });
}

- (void)txtRecordWithCompletionBlock:(void (^)(NSString *))completionBlock
{
    if (!completionBlock) {
        return;
    }
    self.entryKey = nil;
    self.completionBlock = completionBlock;
    
    if (!self.domainName) {
        return;
    }
    
    [self fetchDNSResult];
}

- (void)entryForKey:(NSString *)key withCompletionBlock:(void (^)(NSString *result))completionBlock
{
    if (!completionBlock) {
        return;
    }
    
    self.completionBlock = completionBlock;
    self.entryKey = key;
    
    if (!self.domainName) {
        return;
    }
    
    [self fetchDNSResult];
}

#pragma mark - Private methods

static void queryCallback(DNSServiceRef sdRef,
                          DNSServiceFlags flags,
                          uint32_t interfaceIndex,
                          DNSServiceErrorType errorCode,
                          const char *fullname,
                          uint16_t rrtype,
                          uint16_t rrclass,
                          uint16_t rdlen,
                          const void *rdata,
                          uint32_t ttl,
                          void *context)
{
    if (errorCode != kDNSServiceErr_NoError) {
        [(__bridge ATOMDNSQuery *)context failed:errorCode];
    }
    
    if (((flags & kDNSServiceFlagsAdd) != 0) && (rdlen > 1)) {
        NSMutableData *txtData = [NSMutableData dataWithCapacity:rdlen];
        
        for (NSUInteger i = 1; i < rdlen; i += 256) {
            [txtData appendBytes:rdata + i length:MIN(rdlen - i, 255)];
        }
        
        [(__bridge ATOMDNSQuery *)context receivedData:txtData];
    }
}

- (void)receivedData:(NSData *)data
{
    __block NSString *txt = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSASCIIStringEncoding];
    if (self.entryKey != nil) {
        NSArray *entries = [txt componentsSeparatedByString:@"\n"];
        [entries enumerateObjectsUsingBlock:^(NSString *_Nonnull entry, NSUInteger idx, BOOL *_Nonnull stop) {
            if([entry containsString:kDNSVersionKey] || [entry containsString:kDNStimestamp]){
                NSArray *toupleEntries = [entry componentsSeparatedByString:@";"];
                [toupleEntries enumerateObjectsUsingBlock:^(NSString *_Nonnull touple, NSUInteger idVal, BOOL *_Nonnull exit) {
                    if ([touple hasPrefix:self.entryKey]) {
                        *stop = YES;
                        *exit = YES;
                        txt = [[touple componentsSeparatedByString:@"="] lastObject];;
                        
                    }
                }];
            }
        }];
    }
    self.entryKey = nil;
    self.completionBlock(txt);
}

- (void)failed:(DNSServiceErrorType)theErrorCode
{
    self.completionBlock(nil);
}

@end
