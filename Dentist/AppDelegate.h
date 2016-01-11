//
//  AppDelegate.h
//  Dentist
//
//  Created by Ben on 16/1/10.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *rootNavigationController;

+ (AppDelegate *)sharedAppDelegate;

- (void)replaceRootControllerBy:(UIViewController *)vc;
- (void)replaceRootControllerBy:(UIViewController *)vc completion:(Block)completeBlock;
@end

