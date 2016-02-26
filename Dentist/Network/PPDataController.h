//
//  PPDataController.h
//  Dentist
//
//  Created by Ben on 1/10/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPDataControllerError.h"
#import "AFHTTPRequestOperation.h"

typedef enum {
    RequestMethodGET,
    RequestMethodPUT,
    RequestMethodPOST,
    RequestMethodDelete,
} RequestMethod;

@protocol PPDataControllerDelegate;

@interface PPDataController : NSObject

//请求成功/失败的回调对象
@property (nonatomic, weak) id <PPDataControllerDelegate> delegate;
@property (nonatomic, strong) AFHTTPRequestOperation *httpOperation;
//存requestWithArgs:方法带的参数（若不带，则用子类requestURLArgs）
@property (nonatomic, readonly) NSDictionary *requestArgs;
//最终发送的request的完整URL
@property (nonatomic, strong) NSString *aURLString;
//请求成功/失败回调的时间
@property (nonatomic, strong) NSDate *requestFinishDate;
//是否正在请求过程中
@property (nonatomic, readonly) BOOL isRequesting;

@property (nonatomic, assign) BOOL disableFailTips;//是否显示加载失败的提示, 默认为NO,显示提示, YES的时候不显示

#pragma mark - 构造方法

//单件网络请求的构造方法
+ (instancetype)sharedDataController;
//非单件网络请求的构造方法
- (instancetype)initWithDelegate:(id <PPDataControllerDelegate>)aDelegate;

#pragma mark - 可调用的接口
//开始发请求，可直接带上参数args，也可以不带（不带会使用子类重写的requestURLArgs方法得到参数）
- (void)requestWithArgs:(NSDictionary *)args;
//根据NSURLRequest构造AFHTTPRequestOperation并且异步启动
- (void)requestWithAFNetworking:(NSURLRequest *)request;
//取消请求
- (void)cancelRequest;

+ (NSString *)makeURLParamStringWithArgs:(NSDictionary *)args;
//对string做URL编码
- (NSString *)encodeURIComponent:(NSString *)string;

#pragma mark - 一些常用的URL域名前缀

- (NSString *)dentistHost;

#pragma mark - 需重写的回调

//设置请求的URL（不要带任何参数）
- (NSString *)requestPath;
//返回数据的解析
- (BOOL)parseContent:(NSString *)content;

#pragma mark - 可重写的回调

//设置请求的Method，默认按Get方式请求
- (RequestMethod)requestMethod;
//若调用requestWithArgs:带的参数字典为空，则回调该方法，返回结果为参数，默认为空(不支持POST请求)
- (NSDictionary *)requestURLArgs;
- (NSInteger)requestTimeout;
//缓存的键值(默认为nil，即不缓存)
- (NSString *)cacheKeyName;
- (NSDictionary *)requestHTTPHeaderField;
- (NSDictionary *)requestHTTPBody;
- (NSDictionary *)requestHTTPBodyPlainJsonParams;
//请求将要开始时调用
- (void)requestWillStart;

@end

@protocol PPDataControllerDelegate <NSObject>
@optional
//数据请求成功回调
- (void)loadingDataFinished:(PPDataController *)controller;
//数据请求失败回调
- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error;
@end
