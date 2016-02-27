//
//  DeliverTypeVC.m
//  Dentist
//
//  Created by Ben on 16/2/25.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "DeliverTypeVC.h"

@interface DeliverTypeVC ()

@property (weak, nonatomic) IBOutlet UIButton *kuaidiChoiceButton;
@property (weak, nonatomic) IBOutlet UIButton *zitiChoiceButton;
@property (weak, nonatomic) IBOutlet UILabel *kuaidiPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *zitiPriceLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *deliverTypeButtonsArray;
@property (nonatomic, assign) CGFloat deliverPrice;

@end

@implementation DeliverTypeVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUIReleated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)initUIReleated {
    self.kuaidiPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f", [[self.priceArray objectAtIndex:0] floatValue]];
    self.zitiPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f", [[self.priceArray objectAtIndex:1] floatValue]];
    
    if (self.deliverType == DeliverType_KuaiDi) {
        self.kuaidiChoiceButton.selected = YES;
        self.deliverPrice = [[self.priceArray objectAtIndex:0] floatValue];
    } else if (self.deliverType == DeliverType_ZiTi) {
        self.zitiChoiceButton.selected = YES;
        self.deliverPrice = [[self.priceArray objectAtIndex:1] floatValue];
    }
}

#pragma mark - IBActions

- (IBAction)didClickChoiceButtonAction:(UIButton *)sender {
    for (UIButton *btn in self.deliverTypeButtonsArray) {
        btn.selected = NO;
    }
    
    sender.selected = YES;
    self.deliverType = sender.tag;
    self.deliverPrice = [[self.priceArray objectAtIndex:sender.tag] floatValue];
}

- (IBAction)didClickCancelButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCancelButtonInDeliverTypeVC)]) {
        [self.delegate didClickCancelButtonInDeliverTypeVC];
    }
}

- (IBAction)didClickConfirmButtonAction:(id)sender {
    BOOL hasSelectedType = NO;
    for (UIButton *btn in self.deliverTypeButtonsArray) {
        if (btn.selected) {
            hasSelectedType = YES;
            break;
        }
    }
    
    if (!hasSelectedType) {
        [Utilities showToastWithText:@"您还没有选择配送方式" withImageName:nil blockUI:NO];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didClickConfirmButtonWithDeliverType:price:)]) {
        [self.delegate didClickConfirmButtonWithDeliverType:self.deliverType price:self.deliverPrice];
    }
}

@end
