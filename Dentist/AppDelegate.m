//
//  AppDelegate.m
//  Dentist
//
//  Created by Ben on 16/1/10.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "AppDelegate.h"
#import "AppInitializer.h"
#import "AppDeinitializer.h"
#import "LaunchViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate () <
    WXApiDelegate>

@end

@implementation AppDelegate

#pragma mark - Public methods

+ (AppDelegate *)sharedAppDelegate {
    UIApplication *app = [UIApplication sharedApplication];
    return (AppDelegate *)app.delegate;
}

- (void)replaceRootControllerBy:(UIViewController *)vc {
    self.rootNavigationController = [[BaseNavigationController alloc] initWithRootViewController:vc];
    self.rootNavigationController.navigationBarHidden = YES;
    self.window.rootViewController = self.rootNavigationController;
}

- (void)replaceRootControllerBy:(UIViewController *)vc
                     completion:(Block)completeBlock {
    [self replaceRootControllerBy:vc];
    
    if (completeBlock) {
        completeBlock();
    }
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AppInitializer sharedInstance] initiateAppAfterLaunching];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    BaseNavigationController *navigationVC = [BaseNavigationController new];
    UIViewController* launchVC = [[LaunchViewController alloc] init];
    navigationVC.navigationBar.hidden = YES;
    [navigationVC pushViewController:launchVC animated:NO];
    
    self.window.rootViewController = navigationVC;
    
    [WXApi registerApp:kWeiXinAppID];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self application:application openURL:url options:@{}];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self application:application openURL:url options:@{}];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    NSLog(@"scheme:%@",[url scheme]);
    if ([[url scheme] isEqualToString:@"com.toboom.yayiabc"]) {
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             NSLog(@"result = %@",resultDic);
                                         }];
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      NSLog(@"result = %@",resultDic);
                                                  }];
        
        return YES;
    } else {
        return [WXApi handleOpenURL:url delegate:self];
    }
}

#pragma mark - WXApiDelegate

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
- (void)onReq:(BaseReq *)req {
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp *)resp {
    // 建议支付、分享的应答处理中各自去判断
    
    { // 支付
        [component.payment.wechatpay process:resp];
    }
    
    { // 分享
        switch (resp.errCode) {
            case WXSuccess:
                DDLogInfo(@"微信分享成功");
                break;
            case WXErrCodeCommon:
                DDLogError(@"微信分享错误：普通错误类型");
                break;
            case WXErrCodeUserCancel:
                DDLogError(@"微信分享错误：用户点击取消并返回");
                break;
            case WXErrCodeSentFail:
                DDLogError(@"微信分享错误：发送失败");
                break;
            case WXErrCodeAuthDeny:
                DDLogError(@"微信分享错误：授权失败");
                break;
            case WXErrCodeUnsupport:
                DDLogError(@"微信分享错误：微信不支持");
                break;
            default:
                break;
        }
    }
}


@end
