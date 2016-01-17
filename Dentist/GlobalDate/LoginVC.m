//
//  LoginVC.m
//  Dentist
//
//  Created by 王涛 on 16/1/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "LoginVC.h"
#import "LoginVM.h"
#import "RegistVC.h"

@interface LoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextFileld;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) LoginVM *loginVM;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initNavigationBar];
    [self initUI];
}

- (void)initNavigationBar {
    self.title = @"登录";
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"忘记密码" style:UIBarButtonItemStylePlain target:self action:@selector(onForgetPassword)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(onRegist)]];
}

- (void)initUI {
    self.loginBtn.layer.cornerRadius = self.loginBtn.height/2;
    self.loginBtn.layer.masksToBounds = YES;
    self.nameTextFileld.delegate = self;
    self.passwordTextField.delegate = self;
    // 主动获取焦点
    [self.nameTextFileld becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Response

- (IBAction)onLoginBtn:(UIButton *)sender {
    [self.loginVM loginWithName:self.nameTextFileld.text PassWord:self.passwordTextField.text];
}

- (void)onForgetPassword {
    //找回密码
}

- (void)onRegist {
    //注册
    RegistVC *registVC = [[RegistVC alloc] initWithNibName:@"RegistVC" bundle:nil];
    [self.navigationController pushViewController:registVC animated:YES];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidChange:(UITextField *)textField {
    static BOOL moblieResult;
    static BOOL passwordResult;
    if (textField == self.nameTextFileld) {
        if (textField.text.length > 1) {
            moblieResult = YES;
            if (moblieResult && passwordResult) {
//                self.loginBtn.enabled = YES;
            }
        }
        
    } else if (textField == self.passwordTextField) {
        if (textField.text.length > 6 && textField.text.length < 20) {
            passwordResult = YES;
            if (moblieResult && passwordResult) {
//                self.loginBtn.enabled = YES;
            }
        }
    }
}

- (LoginVM *)loginVM {
    if (!_loginVM) {
        _loginVM = [[LoginVM alloc] init];
    }
    return _loginVM;
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
