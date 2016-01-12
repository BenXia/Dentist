//
//  PPDataController.m
//  Dentist
//
//  Created by Ben on 1/10/16.
//  Copyright (c) 2016 Dentist. All rights reserved.

#import "PPDataController.h"
#import "PPDataCache.h"
#import "NSString+Additions.h"
#import "NSURL+Additions.h"
#import "AppDelegate.h"

static NSMutableDictionary *sharedInstances = nil;

NSString* const kDataControllerErrorDomain = @"NetworkErrorDomain";

@interface PPDataController ()

@end

@implementation PPDataController

#pragma mark - 构造方法

+ (instancetype)sharedDataController {
    PPDataController *aController;
    
    @synchronized(self) {
        if (sharedInstances == nil) {
            sharedInstances = [[NSMutableDictionary alloc] init];
        }
        
        NSString *keyName = NSStringFromClass([self class]);
        if (keyName) {
            aController = [sharedInstances objectForKey:keyName];
            
            if (aController == nil) {
                aController = [[self alloc] init];
                
                [sharedInstances setObject:aController forKey:keyName];
            }
        }
    }
    
    return aController;
}

- (instancetype)initWithDelegate:(id <PPDataControllerDelegate>)aDelegate {
    self = [super init];
    
    if (self) {
        self.delegate = aDelegate;
        self.httpOperation = nil;
        self.aURLString = nil;
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithDelegate:nil];
}

- (void)dealloc {
    self.delegate = nil;
    
    if (self.httpOperation != nil) {
        [self.httpOperation cancel];
        self.httpOperation = nil;
    }
}

#pragma mark - 可调用的接口

// 开始发请求，可直接带上参数args，也可以不带（不带除POST类型请求会使用子类重写的requestURLArgs方法得到参数）
- (void)requestWithArgs:(NSDictionary *)args {
    _requestArgs = nil;

    _requestArgs = args;

    if (!_requestArgs) {
        _requestArgs = [self requestURLArgs];
    }

    // 取消当前的请求
    [self cancelRequest];

    NSString *cache = nil;

    // 尝试读取缓存
    if ([self cacheKeyName] != nil) {
        PPDataCache *dataCache = [PPDataCache sharedPPDataCache];
        cache = [dataCache cacheForKey:[self cacheKeyName]];
    }

    NSMutableURLRequest *urlRequest = nil;
    
    switch ([self requestMethod]) {
        case RequestMethodGET: {
            urlRequest = [NSMutableURLRequest requestWithURL:[self makeURLWithArgs:_requestArgs]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:[self requestTimeout]];
            [urlRequest setHTTPMethod:@"GET"];
        }
            break;
            
        case RequestMethodPUT: {
            
            urlRequest = [NSMutableURLRequest requestWithURL:[self makeURLWithArgs:_requestArgs]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:[self requestTimeout]];
            [urlRequest setHTTPMethod:@"PUT"];
        }
            break;
            
        case RequestMethodPOST: {
            
            urlRequest = [NSMutableURLRequest requestWithURL:[self makeURLWithArgs:_requestArgs]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:[self requestTimeout]];
            [urlRequest setHTTPMethod:@"POST"];
            [urlRequest setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
            
            if (self.requestHTTPBody) {
                [urlRequest setHTTPBody:[[PPDataController makeQueryStringFromArgs:self.requestHTTPBody] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
            break;
            
        case RequestMethodDelete: {
            urlRequest = [NSMutableURLRequest requestWithURL:[self makeURLWithArgs:_requestArgs]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:[self requestTimeout]];
            [urlRequest setHTTPMethod:@"DELETE"];
        }
            break;
            
        default:
            break;
    }

    //设置Http header
    if (self.requestHTTPHeaderField && self.requestHTTPHeaderField.count > 0) {
        [self.requestHTTPHeaderField enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            [urlRequest addValue:value
              forHTTPHeaderField:key];
        }];
    }

    //设置User-Agent,规避被封
    [urlRequest addValue:[NSURL userAgent] forHTTPHeaderField:@"User-Agent"];

    if (cache == nil) {
        [self requestWithAFNetworking:urlRequest];
    } else {
        if ([self parseContent:cache]) {
            if (self.delegate
                && [self.delegate respondsToSelector:@selector(loadingDataFinished:)]) {

                [self.delegate performSelector:@selector(loadingDataFinished:)
                                    withObject:self];
            }
        } else {
            NSAssert(NO, @"缓存了错误的接口");

            [self requestWithAFNetworking:urlRequest];
        }
    }
}

- (void)cancelRequest {
    [self cancelRequestWithAFNetworking];
}

- (BOOL)isRequesting {
    return (self.httpOperation != nil);
}

// 对参数列表生成URL编码后字符串
+ (NSString *)makeQueryStringFromArgs:(NSDictionary *)args {
    NSMutableString *formatString = nil;
    
    for (NSString *key in args) {
        if (formatString == nil) {
            formatString = [NSMutableString stringWithFormat:@"%@=%@", key, [[args valueForKey:key] URLEncodedString]];
        } else {
            [formatString appendFormat:@"&%@=%@", key, [[args valueForKey:key] URLEncodedString]];
        }
    }
    
    return [NSString stringWithString:formatString];
}

// 对string做URL编码
- (NSString *)encodeURIComponent:(NSString *)string {
    if (string == nil) {
        return nil;
    }
    
    CFStringRef cfUrlEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                             (CFStringRef)string,NULL,
                                                                             (CFStringRef)@"!#$%&'()*+,/:;=?@[]",
                                                                             kCFStringEncodingUTF8);
    
    NSString *urlEncoded = nil;
    
    if (cfUrlEncodedString != NULL) {
        urlEncoded = [NSString stringWithString:CFBridgingRelease(cfUrlEncodedString)];
    }
    
    return urlEncoded;
}

#pragma mark - 一些常用的URL域名前缀

- (NSString *)dentistHost {
    return @"http://api.x.jiefangqian.com/";
}

#pragma mark - 需重写的回调

- (BOOL)parseContent:(NSString *)content {
    // 子类自己实现
    NSAssert(NO, @"require implementation");
    return NO;
}

#pragma mark - 可重写的回调

- (RequestMethod)requestMethod {
    // 子类可自己实现以修改请求方式，默认按Get方式请求
    return RequestMethodGET;
}

- (NSString *)requestPath {
    // 子类可自己实现
    return [self dentistHost];
}

- (NSDictionary *)requestURLArgs {
    // 子类可选择性重写, POST请求不支持
    return nil;
}

- (NSInteger)requestTimeout {
    // 子类可选择性重写, 默认为30秒
    return 30.0;
}

- (NSString *)cacheKeyName {
    // 如果需要支持缓存，必须实现该方法
    return nil;
}

- (NSDictionary *)requestHTTPHeaderField {
    // 子类根据需要使用
    return nil;
}

- (NSDictionary *)requestHTTPBody {
    // 子类根据需要实现
    return nil;
}

// 根据URL域名和参数构造最终的完整URL
- (NSURL *)makeURLWithArgs:(NSDictionary *)args {
    NSString *formatString = [self makeParameterStringWithArgs:args];
    
    NSString *aURLString = nil;
    if (formatString) {
        if ([[self requestPath] rangeOfString:@"?"].location != NSNotFound) {
            aURLString = [NSString stringWithFormat:@"%@&%@", [self requestPath], formatString];
        } else {
            aURLString = [NSString stringWithFormat:@"%@?%@", [self requestPath], formatString];
        }
    } else {
        aURLString = [self requestPath];
    }
    self.aURLString = aURLString;
    return [NSURL URLWithString:aURLString];
}

- (void)requestWillStart {
    // 请求将要开始时调用
}

#pragma mark - Private Methods

- (NSString *)makeParameterStringWithArgs:(NSDictionary *)argsvar {
    NSDictionary *newArgument = argsvar;
    NSMutableString *formatString = nil;
    
    NSDictionary *commonArgument = @{@"v":@"0.0.1"};
    
    NSMutableDictionary *newCommonArgument = [NSMutableDictionary dictionaryWithDictionary:commonArgument];
    [newCommonArgument addEntriesFromDictionary:argsvar];  // args里面的Key会覆盖默认的key
    newArgument = newCommonArgument;
    
    for (NSString *key in newArgument) {
        if (formatString == nil) {
            formatString = [NSMutableString stringWithFormat:@"%@=%@", key, [self encodeURIComponent:[newArgument valueForKey:key]]];
        } else {
            [formatString appendFormat:@"&%@=%@", key, [self encodeURIComponent:[newArgument valueForKey:key]]];
        }
    }
    
    return formatString;
}

- (NSDate *)dateFromDayString:(NSString *)dayString {
    static NSDateFormatter *formatter = nil;
    
    if (!formatter) {
        @synchronized(self) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
            [formatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss z"];
        }
    }
    
    return [formatter dateFromString:dayString];
}

- (void)showRequestFailedMessage {
    NSLog(@"<PPDataController>self=%@",self);
    if (self.disableFailTips) {
        return;
    }
    [Utilities showToastWithText:@"网络不给力, 请稍后再试"];
}

#pragma mark - AFNetworking Related

- (void)requestWithAFNetworking:(NSURLRequest *)request {
    NSLog(@"AFNetworking Request: %@", request.URL);
    AFHTTPRequestOperation *newHttpOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    self.httpOperation = newHttpOperation;
    newHttpOperation = nil;
    
    __weak PPDataController *weakSelf = self;
    [self.httpOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf requestFinishedWithAFNetworking:operation];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf requestFailedWithAFNetworking:operation];
    }];
    
    [self requestWillStart];
    [self.httpOperation start];
}

- (void)cancelRequestWithAFNetworking {
    if (self.httpOperation != nil) {
        [self.httpOperation cancel];
        self.httpOperation = nil;
    }
}

- (void)requestFinishedWithAFNetworking:(AFHTTPRequestOperation *)operation {
    self.requestFinishDate = [NSDate date];
    self.httpOperation = nil;
    
    NSInteger statusCode = operation.response.statusCode;
    if (200 == statusCode) {
        if ([self parseContent:[operation responseString]]) {
            if (self.delegate
                && [self.delegate respondsToSelector:@selector(loadingDataFinished:)]) {
                
                if ([self cacheKeyName] != nil) {
                    PPDataCache *dataCache = [PPDataCache sharedPPDataCache];
                    
                    [dataCache setCache:[operation responseString]
                                 forKey:[self cacheKeyName]];
                }
                
                [self.delegate performSelector:@selector(loadingDataFinished:)
                                    withObject:self];
            }
        } else {
            if (self.delegate
                && [self.delegate respondsToSelector:@selector(loadingData:failedWithError:)]) {
                
                [self.delegate performSelector:@selector(loadingData:failedWithError:)
                                    withObject:self
                                    withObject:[NSError errorWithDomain:kDataControllerErrorDomain
                                                                   code:PPDataParseError
                                                               userInfo:@{@"错误原因":@"解析错误"}]];
            }
        }
    } else {
        
        [self showRequestFailedMessage];
        
        //处理delegate方法
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(loadingData:failedWithError:)]) {
            
            [self.delegate performSelector:@selector(loadingData:failedWithError:)
                                withObject:self
                                withObject:[NSError errorWithDomain:kDataControllerErrorDomain
                                                               code:PPDataStatusCodeError
                                                           userInfo:@{@"错误原因":[NSString stringWithFormat:@"%zd : %@", statusCode, [NSHTTPURLResponse localizedStringForStatusCode:statusCode]]}]];
        }
    }
}

- (void)requestFailedWithAFNetworking:(AFHTTPRequestOperation *)operation {
    NSLog(@"AFNetworking Request failed  URL: %@ \n Error code: %ld \n Response string:%@ Response error: %@ \n", operation.request.URL, (long)[operation.error code], operation.responseString, [operation.error localizedDescription]);
    self.requestFinishDate = [NSDate date];
    self.httpOperation = nil;
    
    if ([operation.error code] != PPURLErrorCancelled) {
        [self showRequestFailedMessage];
    }
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(loadingData:failedWithError:)]) {
        [self.delegate performSelector:@selector(loadingData:failedWithError:)
                            withObject:self
                            withObject:operation.error];
    }
}

@end
