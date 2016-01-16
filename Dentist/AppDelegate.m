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

@interface AppDelegate ()

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

@end
