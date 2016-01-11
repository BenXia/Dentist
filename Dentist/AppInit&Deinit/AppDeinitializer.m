//
//  AppDeinitializer.m
//  Dentist
//
//  Created by Ben on 15/8/22.
//
//

#import "AppDeinitializer.h"
#import "AppDelegate.h"

@implementation AppDeinitializer

static AppDeinitializer* sInstance = nil;

+ (AppDeinitializer*)sharedInstance {
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

#pragma makr - some method

- (void)cleanUpCommonPartWithCleanHuanXinDeviceToken:(BOOL)cleanHuanXinDeviceToken {    // 退出登录

}

- (void)cleanUpWhenLogout {

}

- (void)cleanUpWhenSessionInvalid {
}

- (void)cleanUpWhenTokenInvalid {
}

@end
