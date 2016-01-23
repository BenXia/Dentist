//
//  LoginVM.m
//  Dentist
//
//  Created by 王涛 on 16/1/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "LoginVM.h"
#import "LoginDC.h"

@interface LoginVM ()<PPDataControllerDelegate>
@property (nonatomic, strong) LoginDC *loginRequest;
@end

@implementation LoginVM

- (void)loginWithName:(NSString *)name PassWord:(NSString *)password {
    self.loginRequest = [[LoginDC alloc] initWithDelegate:self];
    self.loginRequest.mobile = name;
    self.loginRequest.password = password;
    [self.loginRequest requestWithArgs:nil];
}

- (void)autoLogin {
    self.loginRequest = [[LoginDC alloc] initWithDelegate:self];
    self.loginRequest.mobile = [UserCache sharedUserCache].username;
    self.loginRequest.password = [UserCache sharedUserCache].password;
    [self.loginRequest requestWithArgs:nil];
}

#pragma mark - PPDataControllerDelegate

- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error {
    if (controller == self.loginRequest) {
        [Utilities showToastWithText:[NSString stringWithFormat:@"登录失败:%@", error]];
        
    }
}

- (void)loadingDataFinished:(PPDataController *)controller {
    if (controller == self.loginRequest) {
        if (self.loginRequest.loginSuccess) {
            NSLog(@"登录成功");
            [[MainViewManager sharedInstance] loadMainVC];
            [[MainViewManager sharedInstance] selectTabHomeVC];

        } else {
            [Utilities showToastWithText:@"登录失败"];
            //注册接口还未调通
            [[MainViewManager sharedInstance] loadMainVC];
            [[MainViewManager sharedInstance] selectTabHomeVC];
        }
    }
}


@end
