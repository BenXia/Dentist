//
//  BaseNavigationController.h
//  Dentist
//
//  Created by Ben on 10/15/15.
//  Copyright (c) 2015 Dentist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController

#pragma mark - 

- (UIViewController *)childViewControllerForStatusBarStyle;

@end
