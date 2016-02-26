//
//  SetNickVC.m
//  Dentist
//
//  Created by 王涛 on 16/2/21.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "SetNickVC.h"
#import "SetNickDC.h"

@interface SetNickVC ()<PPDataControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;
@property (nonatomic, strong) SetNickDC *setNickRequest;
@end

@implementation SetNickVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"昵称";
    self.nickTextField.text = self.nick;
    self.nickTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didClickOnDone)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)didClickOnDone {
    self.setNickRequest = [[SetNickDC alloc] initWithDelegate:self];
    self.setNickRequest.nick = self.nickTextField.text;
    [self.setNickRequest requestWithArgs:nil];
}

#pragma mark - PPDataControllerDelegate

- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error {
    if (controller == self.setNickRequest) {
        [Utilities showToastWithText:[NSString stringWithFormat:@"设置昵称失败"]];
    }
}

- (void)loadingDataFinished:(PPDataController *)controller {
    if (controller == self.setNickRequest) {
        [[GCDQueue mainQueue] queueBlock:^{
            if (self.setNickRequest.responseCode == 200) {
                [Utilities showToastWithText:[NSString stringWithFormat:@"设置昵称成功"]];
                [UserInfoModel sharedUserInfoModel].nickName = self.nickTextField.text;
            } else if (self.setNickRequest.responseCode == 40001) {
                [Utilities showToastWithText:self.setNickRequest.responseMsg];
            }
            
        }];
    }}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
