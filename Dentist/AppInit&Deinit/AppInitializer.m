//
//  AppInitializer.m
//  Dentist
//
//  Created by Ben on 15/8/3.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "AppInitializer.h"
#import "AppDelegate.h"
#import "AppAppearance.h"
#import "LoginVM.h"
#import "IQKeyboardManager.h"

@interface AppInitializer ()
@property (nonatomic, strong)LoginVM *loginVM;
@end

@implementation AppInitializer

static AppInitializer* sInstance = nil;

// 单例模式，整个进程仅此一个实例，来打印所有的log
+ (AppInitializer*)sharedInstance {
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        sInstance = [[self alloc] init];
    });
    return sInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sInstance == nil) {
            sInstance = [super allocWithZone:zone];
            return sInstance;
        }
    }
    return sInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - public APIs

- (void)initiateAppAfterLaunching {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakself initiateLocalModule];
        [weakself initiateWithServerData];
    });
}

#pragma mark - initiate with server data

- (void)initiateWithServerData {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *lastShownGuideAppVersion = [[NSUserDefaults standardUserDefaults] stringForKey:kLastShownGuidanceVCAppVersion];
        if (!lastShownGuideAppVersion || ![lastShownGuideAppVersion isEqualToString:[AppSystem appVersion]]) {
            [[MainViewManager sharedInstance] loadGuidanceVCWithCompleteBlock:^{
                [self login];
            }];
        } else {
            [self login];
        }
    });
}

- (void)login{
    //登录
    if ([UserCache sharedUserCache].username.length>0 && [UserCache sharedUserCache].password.length>0) {
        //自动登录
        [self.loginVM autoLogin];
    } else {
        //手动登录
        [[MainViewManager sharedInstance] loadLoginVC];
    }
}

#pragma mark - Initiate local

- (void)initiateLocalModule {
    
    // 前端所有时间计算以北京时区为准GMT+8
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];
    
    // 初始化远程图片缓存配置
    [self initSDImageCacheConfiguration];
    
    // 初始化外观类
    [AppAppearance sharedAppearance];
    
    // 键盘管理 第三方
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
}

#pragma mark - Private methods

- (void)initSDImageCacheConfiguration {
    [SDImageCache sharedImageCache].maxMemoryCost = 30 * 1024 * 1024;   // 30M内存缓存，非精确值
    [SDImageCache sharedImageCache].maxCacheAge = [[NSDate distantFuture] timeIntervalSince1970];  // 永远不过期，通过下面的缓存大小限制，减轻服务器压力
    [SDImageCache sharedImageCache].maxCacheSize = 50 * 1024 * 1024;    // 50M磁盘缓存，精确值
}

#pragma mark - Getters

- (LoginVM *)loginVM {
    if (!_loginVM) {
        _loginVM = [[LoginVM alloc] init];
    }
    return _loginVM;
}

@end
