//
//  ProductBriefInfoCell.m
//  Dentist
//
//  Created by Ben on 16/2/2.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "ProductBriefInfoCell.h"

@interface ProductBriefInfoCell ()

@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet QQingImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *editContentView;
@property (weak, nonatomic) IBOutlet UIButton *editMinusButton;
@property (weak, nonatomic) IBOutlet UITextField *editCountTextField;
@property (weak, nonatomic) IBOutlet UIButton *editPlusButton;
@property (weak, nonatomic) IBOutlet UILabel *briefInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *subContentView1;
@property (weak, nonatomic) IBOutlet UIView *subContentView2;
@property (weak, nonatomic) IBOutlet UILabel *countInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;

@end

@implementation ProductBriefInfoCell

- (void)awakeFromNib {
    // Initialization code
    self.productTitleLabel.numberOfLines = 2;
    
    self.editMinusButton.enabled = YES;
    self.editPlusButton.enabled = YES;
    self.editCountTextField.layer.borderWidth = 1;
    self.editCountTextField.layer.borderColor = RGB(236, 236, 236).CGColor;
    
    self.productImageView.layer.borderWidth = 1;
    self.productImageView.layer.borderColor = RGB(236, 236, 236).CGColor;
    self.productImageView.supportProgressIndicator = NO;
    self.productImageView.supportFailRetry = NO;
    self.productImageView.defaultImageName = @"微信";
    [self.productImageView setImageURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/pic/item/d788d43f8794a4c2b3e5d2140df41bd5ac6e39ce.jpg"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBActions

- (IBAction)didClickSelectButtonAction:(id)sender {
    self.selectButton.selected = !self.selectButton.selected;
}

- (IBAction)didClickEditMinusButtonAction:(id)sender {
    int currentCount = [self.editCountTextField.text intValue];
    if (currentCount <= 1) {
        currentCount = 0;
        self.editMinusButton.enabled = NO;
    } else {
        currentCount--;
    }
    
    self.editCountTextField.text = [NSString stringWithFormat:@"%d", currentCount];
}

- (IBAction)didClickEditPlusButtonAction:(id)sender {
    int currentCount = [self.editCountTextField.text intValue];
    currentCount++;
    self.editMinusButton.enabled = YES;
    
    self.editCountTextField.text = [NSString stringWithFormat:@"%d", currentCount];
}

- (IBAction)didClickEditButtonAction:(id)sender {
    
}

- (IBAction)didClickDeleteButtonAction:(id)sender {
    
}

- (IBAction)didClickFinishButtonAction:(id)sender {
    
}

@end
