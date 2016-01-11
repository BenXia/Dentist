//
//  AppAppearance.m
//  Dentist
//
//  Created by Ben on 5/20/15.
//
//

#import "AppAppearance.h"

@implementation AppAppearance

#pragma mark - singleton

static AppAppearance* sInstance = nil;

// 单例模式，整个进程仅此一个实例
+ (instancetype) sharedAppearance {
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        sInstance = [[self alloc] init];
        [sInstance setDefaultAppearance];
    });
    return sInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
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

#pragma mark - set default

- (void)setDefaultAppearance {
    [self statusBarAppearance];
    [self navigationBarAppearance];
    [self tabBarItemAppearance];
}

#pragma mark - Initialization

- (void)statusBarAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)navigationBarAppearance {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0f]];
    
    //设置导航栏返回按钮颜色
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    if (IOS8_OR_LATER) {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    
    UIFont *font = [UIFont systemFontOfSize:18.0];
    UIColor *foregroundColor = RGB(51, 51, 51);
    UIColor *backgroundColor = [UIColor clearColor];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          foregroundColor, NSForegroundColorAttributeName,
                                                          backgroundColor, NSBackgroundColorAttributeName,
                                                          font, NSFontAttributeName,
                                                          nil]];
    
    //隐藏导航栏文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
} 

- (void)tabBarItemAppearance {
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor lightGrayColor], NSForegroundColorAttributeName,
                                                       [UIFont systemFontOfSize:16.0], NSFontAttributeName,
                                                       nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor greenColor], NSForegroundColorAttributeName,
                                                       [UIFont systemFontOfSize:16.0], NSFontAttributeName,
                                                       nil]
                                             forState:UIControlStateSelected];
}

@end
