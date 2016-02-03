//
//  MainPageTabBarVC.m
//  Dentist
//
//  Created by Ben on 15/12/31.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "MainPageTabBarVC.h"

@interface MainPageTabBarVC ()

@end

@implementation MainPageTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

@end
