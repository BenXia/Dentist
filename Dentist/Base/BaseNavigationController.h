//
//  BaseNavigationController.h
//  Dentist
//
//  Created by Ben on 10/15/15.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController

#pragma mark - 

- (UIViewController *)childViewControllerForStatusBarStyle;

@end
