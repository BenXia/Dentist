//
//  HomePageVC.m
//  Dentist
//
//  Created by Ben on 16/1/10.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "HomePageVC.h"
#import "SendSmsDataController.h"

@interface HomePageVC () <PPDataControllerDelegate>

@property (nonatomic, strong) SendSmsDataController *sendSmsRequest;

@end

@implementation HomePageVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"首页";
        self.tabBarItem.image = [UIImage imageNamed:@"btn_homepage _f"];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage _t"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)testNetworkRequest:(id)sender {
    self.sendSmsRequest = [[SendSmsDataController alloc] initWithDelegate:self];
    self.sendSmsRequest.phoneNumber = @"18818157583";
    [self.sendSmsRequest requestWithArgs:nil];
}

#pragma mark - PPDataControllerDelegate

- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error {
    if (controller == self.sendSmsRequest) {
        [Utilities showToastWithText:[NSString stringWithFormat:@"发送验证码失败:%@", error]];
    }
}

- (void)loadingDataFinished:(PPDataController *)controller {
    if (controller == self.sendSmsRequest) {
        if (self.sendSmsRequest.sendSmsSuccess) {
            [Utilities showToastWithText:@"发送验证码成功"];
        } else {
            [Utilities showToastWithText:@"发送验证码失败:1分钟内不能重复发送"];
        }
    }
}

@end
