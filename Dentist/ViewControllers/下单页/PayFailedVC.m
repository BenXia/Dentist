//
//  PayFailedVC.m
//  Dentist
//
//  Created by Ben on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PayFailedVC.h"
#import "ProfileVC.h"

@interface PayFailedVC ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *wxPayButton;
@property (weak, nonatomic) IBOutlet UILabel *wxInUseLabel;
@property (weak, nonatomic) IBOutlet UIButton *alipayButton;
@property (weak, nonatomic) IBOutlet UILabel *alipayInUseLabel;

@property (weak, nonatomic) IBOutlet UIButton *searchOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *repayButton;

@end

@implementation PayFailedVC

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
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setNavTitleString:@"付款结果"];
    
    [self.searchOrderButton thematizedWithBackgroundColor:[UIColor whiteColor]];
    [self.searchOrderButton circular:self.searchOrderButton.height / 2];
    [self.searchOrderButton setTitleColor:RGB(61, 183, 235)];
    self.searchOrderButton.layer.borderColor = RGB(61, 183, 235).CGColor;
    self.searchOrderButton.layer.borderWidth = 1;
    
    [self.repayButton thematizedWithBackgroundColor:[UIColor themeCyanColor]];
    [self.repayButton circular:self.repayButton.height / 2];
    
    if (self.currentPayType == PayType_WeChat) {
        self.wxInUseLabel.hidden = NO;
    } else {
        self.alipayInUseLabel.hidden = NO;
    }
}

#pragma mark - IBActions

- (IBAction)didClickWXPayOptionButton:(id)sender {
    self.wxPayButton.selected = YES;
    self.alipayButton.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(didChangePayType:)]) {
        [self.delegate didChangePayType:PayType_WeChat];
    }
}

- (IBAction)didClickAlipayOptionButton:(id)sender {
    self.wxPayButton.selected = NO;
    self.alipayButton.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(didChangePayType:)]) {
        [self.delegate didChangePayType:PayType_AliPay];
    }
}

- (IBAction)didClickSearchOrderButtonAction:(id)sender {
    [[MainViewManager sharedInstance] popToRootTabViewControllerWithCompletion:^{
        [[MainViewManager sharedInstance] selectTabProfileVC];
        [(ProfileVC *)([((UINavigationController *)[[MainViewManager sharedInstance].tabBarController.viewControllers objectAtIndex:kMainTabIndexType_ProfilePage]).viewControllers objectAtIndex:0]) showAllOrderListVC];
    }];
}

- (IBAction)didClickRepayButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickPayAgainButtonInPayFailedVC)]) {
        [self.delegate didClickPayAgainButtonInPayFailedVC];
    }
}

@end
