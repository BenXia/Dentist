//
//  PaySuccessVC.m
//  Dentist
//
//  Created by Ben on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PaySuccessVC.h"

@interface PaySuccessVC ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverAddressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiverAddressLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *payDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *createOrderDateLabel;

@property (weak, nonatomic) IBOutlet UIButton *continueBuyButton;

@end

@implementation PaySuccessVC

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

- (void)didClickOnBackButton {
    NSArray *vcs = self.navigationController.viewControllers;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kOrderChangedNotification object:self];
    
    if (vcs.count >= 3) {
        UIViewController *vcToPop = [vcs objectAtIndexIfIndexInBounds:vcs.count - 3];
        [self.navigationController popToViewController:vcToPop animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Private methods

- (void)initUIRelated {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setNavTitleString:@"付款结果"];
    
    self.receiverAddressLabel.numberOfLines = 0;
    [self.continueBuyButton thematizedWithBackgroundColor:[UIColor themeCyanColor]];
    [self.continueBuyButton circular:self.continueBuyButton.height / 2];
    
    self.receiverLabel.text = self.receiverName;
    self.receiverPhoneNumberLabel.text = self.receiverPhoneNumber;
    self.receiverAddressLabel.text = self.receiverAddress;
    
    self.orderNumberLabel.text = self.orderNumberString;
    self.payDateLabel.text = self.payDateString;
    self.createOrderDateLabel.text = self.createOrderDateString;
    
    CGSize size = [self.receiverAddress textSizeWithFont:self.receiverAddressLabel.font
                                       constrainedToSize:CGSizeMake(self.receiverAddressLabel.width, MAXFLOAT)
                                           lineBreakMode:NSLineBreakByCharWrapping];
    self.receiverAddressLabelHeightConstraint.constant = size.height;
    self.topViewHeightConstraint.constant = 195 + ((size.height > 15) ? (size.height - 15) : 0);
}

#pragma mark - IBActions

- (IBAction)didClickContinueBuyButtonAction:(id)sender {
    [[MainViewManager sharedInstance] popToRootTabViewControllerWithCompletion:^{
        [[MainViewManager sharedInstance] selectTabHomeVC];
    }];
}

@end
