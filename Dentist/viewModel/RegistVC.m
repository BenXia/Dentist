//
//  RegistVC.m
//  Dentist
//
//  Created by 王涛 on 16/1/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "RegistVC.h"
#import "AgreementVC.h"
#import "RegistDC.h"

typedef enum : NSUInteger {
    kRegistResonseCodeSuccess = 200,//成功
    kRegistResonseCodeNameEmpty = 40001,//用户名为空
    kRegistResonseCodePasswordEmpty = 40002,//密码为空
    kRegistResonseCodeNameAlreadyExist = 40003,//用户名已存在
    kRegistResonseCodeError = 40004,//内部创建错误
    kRegistResonseCodeMobilEmpty = 40005,//电话为空
    kRegistResonseCodePasswordError = 40006,//密码不是6-20位
    kRegistResonseCodeVerificationCodeError = 401,//验证码错误
    kRegistResonseCodeVerificationCodeExprie = 402,//验证码过期
} kRegistResonseCode;

@interface RegistVC ()<UITextFieldDelegate,PPDataControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *reChectPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIImageView *agreeImage;
@property (nonatomic) BOOL isAgree;
@property (strong, nonatomic) RegistDC *registRequest;
@end

@implementation RegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.title = @"注册";
    //默认同意协议
    self.isAgree = YES;
    self.registBtn.layer.cornerRadius = self.registBtn.height/2;
    self.registBtn.layer.masksToBounds = YES;
    self.nameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    // 主动获取焦点
    [self.nameTextField becomeFirstResponder];
    
    //同意协议按钮的响应事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageView)];
    [self.agreeImage addGestureRecognizer:tap];
}

#pragma mark - Event Response

- (IBAction)onAgreementBtn:(UIButton *)sender {
    AgreementVC *agreementVC = [[AgreementVC alloc] initWithNibName:@"AgreementVC" bundle:nil];
    [self.navigationController pushViewController:agreementVC animated:YES];
}

- (IBAction)onRegistBtn:(UIButton *)sender {
    self.registRequest = [[RegistDC alloc] initWithDelegate:self];
    self.registRequest.mobile = self.nameTextField.text;
    self.registRequest.password = self.passwordTextField.text;
    self.registRequest.code = self.reChectPasswordTextField.text;
    [self.registRequest requestWithArgs:nil];
    
}

- (void)onImageView {
    self.isAgree = !self.isAgree;
    if (self.isAgree) {
        self.agreeImage.image = [UIImage imageNamed:@"Ico_Successed.png"];
    } else {
        self.agreeImage.image = [UIImage imageNamed:@"Ico_Successed.png"];
    }
}

#pragma mark - PPDataControllerDelegate

- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error {
    if (controller == self.registRequest) {
        [Utilities showToastWithText:[NSString stringWithFormat:@"注册失败:%@", error]];
        
    }
}

- (void)loadingDataFinished:(PPDataController *)controller {
    if (controller == self.registRequest) {
        switch (self.registRequest.responseCode) {
            case kRegistResonseCodeSuccess: {
                NSLog(@"注册成功");
                //缓存数据
                [[Cache sharedCache] setUsername:self.nameTextField.text password:self.passwordTextField.text];
                [[MainViewManager sharedInstance] loadMainVC];
                [[MainViewManager sharedInstance] selectTabHomeVC];
            }
                break;
                
            default: {
                [Utilities showToastWithText:self.registRequest.responseMsg];
            }
                break;
        }
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
