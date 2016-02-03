//
//  BaseNavigationController.m
//  Dentist
//
//  Created by Ben on 10/15/15.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end
