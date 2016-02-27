//
//  PayTypeVC.m
//  Dentist
//
//  Created by Ben on 16/2/25.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PayTypeVC.h"

@interface PayTypeVC ()

@property (weak, nonatomic) IBOutlet UIButton *wechatPayChoiceButton;
@property (weak, nonatomic) IBOutlet UIButton *alipayChoiceButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *payTypeButtonsArray;

@end

@implementation PayTypeVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUIRelated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)initUIRelated {
    if (self.payType == PayType_WeChat) {
        self.wechatPayChoiceButton.selected = YES;
    } else if (self.payType == PayType_AliPay) {
        self.alipayChoiceButton.selected = YES;
    }
}

#pragma mark - IBActions

- (IBAction)didClickChoiceButtonAction:(UIButton *)sender {
    for (UIButton *btn in self.payTypeButtonsArray) {
        btn.selected = NO;
    }
    
    sender.selected = YES;
    self.payType = sender.tag;
}

- (IBAction)didClickCancelButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCancelButtonInPayTypeVC)]) {
        [self.delegate didClickCancelButtonInPayTypeVC];
    }
}

- (IBAction)didClickConfirmButtonAction:(id)sender {
    BOOL hasSelectedType = NO;
    for (UIButton *btn in self.payTypeButtonsArray) {
        if (btn.selected) {
            hasSelectedType = YES;
            break;
        }
    }
    
    if (!hasSelectedType) {
        [Utilities showToastWithText:@"您还没有选择支付方式" withImageName:nil blockUI:NO];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didClickConfirmButtonWithPayType:)]) {
        [self.delegate didClickConfirmButtonWithPayType:self.payType];
    }
}

@end
