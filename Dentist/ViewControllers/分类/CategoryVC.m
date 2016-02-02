//
//  CategoryVC.m
//  Dentist
//
//  Created by Ben on 16/1/10.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "CategoryVC.h"

@interface CategoryVC ()

@end

@implementation CategoryVC

#pragma mark - View life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"分类";
        self.tabBarItem.image = [UIImage imageNamed:@"btn_classification_f"];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_classification_t"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self clearNavLeftItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation Style

- (UIColor*)preferNavBarBackgroundColor{
    return [UIColor themeBlueColor];
}

- (UIColor*)preferNavBarNormalTitleColor{
    return [UIColor whiteColor];
}

- (UIColor*)preferNavBarHighlightedTitleColor {
    return kWhiteHighlightedColor;
}

@end
