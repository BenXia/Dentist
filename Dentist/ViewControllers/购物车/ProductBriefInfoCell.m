//
//  ProductBriefInfoCell.m
//  Dentist
//
//  Created by Ben on 16/2/2.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "ProductBriefInfoCell.h"
#import "ShoppingCartModel.h"

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

@property (strong, nonatomic) ShoppingCartModel *shoppingCartModel;

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
    self.productImageView.defaultImageName = kPlaceholderImageView;
    
    self.editContentView.hidden = YES;
    self.productTitleLabel.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCellWithShoppingCartModel:(ShoppingCartModel *)shoppingCartModel {
    self.shoppingCartModel = shoppingCartModel;
    self.productTitleLabel.text = shoppingCartModel.shoppingCartProductTitle;
    [self.productImageView setImageURL:[NSURL URLWithString:shoppingCartModel.shoppingCartProductImage]];
    self.briefInfoLabel.text = shoppingCartModel.shoppingCartProductSids;
    self.priceLabel.text =  [NSString stringWithFormat:@"¥%.2f",[shoppingCartModel.shoppingCartProductPrice floatValue]];
    self.countInfoLabel.text = [NSString stringWithFormat:@"x %d", [shoppingCartModel.shoppingCartProductNumber intValue]];
}

- (void)setCellToEditType {
    self.subContentView1.hidden = YES;
    self.subContentView2.hidden = NO;
    self.editContentView.hidden = NO;
    self.productTitleLabel.hidden = YES;
    self.editCountTextField.text = [NSString stringWithFormat:@"%d", [self.shoppingCartModel.shoppingCartProductNumber intValue]];
}

- (void)setCellToNormalType {
    self.subContentView1.hidden = NO;
    self.subContentView2.hidden = YES;
    self.editContentView.hidden = YES;
    self.productTitleLabel.hidden = NO;
}

- (void)setCellToSelectType {
    self.selectButton.selected = YES;
}

- (void)setCellToUnSelectType {
    self.selectButton.selected = NO;
}

- (void)hideDeleteAndFinishButton {
    self.subContentView1.hidden = YES;
    self.subContentView2.hidden = YES;
}

- (void)showDeleteAndFinishButton {
    self.subContentView1.hidden = NO;
    self.subContentView2.hidden = YES;
}
#pragma mark - IBActions

- (IBAction)didClickSelectButtonAction:(id)sender {
    self.selectButton.selected = !self.selectButton.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedOnSelectButtonWithShoppingCartModel:)]) {
        [self.delegate didClickedOnSelectButtonWithShoppingCartModel:self.shoppingCartModel];
    }
}

- (IBAction)didClickEditMinusButtonAction:(id)sender {
    int currentCount = [self.editCountTextField.text intValue];
    if (currentCount == 1) {
        self.editMinusButton.enabled = NO;
    } else {
        currentCount--;
        self.editPlusButton.enabled = YES;
    }
    
    self.editCountTextField.text = [NSString stringWithFormat:@"%d", currentCount];
    self.countInfoLabel.text = [NSString stringWithFormat:@"x %d", currentCount];
    self.shoppingCartModel.shoppingCartProductNumber = [NSString stringWithFormat:@"%d", currentCount];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedOnReduceButtonWithShoppingCartModel:)]) {
        [self.delegate didClickedOnReduceButtonWithShoppingCartModel:self.shoppingCartModel];
    }
}

- (IBAction)didClickEditPlusButtonAction:(id)sender {
    int currentCount = [self.editCountTextField.text intValue];
    if (self.shoppingCartModel.shoppingCartProductSurplusNumber.intValue <= currentCount) {
        self.editPlusButton.enabled = NO;
    } else {
        currentCount++;
        self.editMinusButton.enabled = YES;
    }
    
    self.editCountTextField.text = [NSString stringWithFormat:@"%d", currentCount];
    self.countInfoLabel.text = [NSString stringWithFormat:@"x %d", currentCount];
    self.shoppingCartModel.shoppingCartProductNumber = [NSString stringWithFormat:@"%d", currentCount];

    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedOnPlusButtonWithShoppingCartModel:)]) {
        [self.delegate didClickedOnPlusButtonWithShoppingCartModel:self.shoppingCartModel];
    }
}

- (IBAction)didClickEditButtonAction:(id)sender {
    self.subContentView1.hidden = YES;
    self.subContentView2.hidden = NO;
    self.editContentView.hidden = NO;
    self.productTitleLabel.hidden = YES;
    self.editCountTextField.text = [NSString stringWithFormat:@"%d", [self.shoppingCartModel.shoppingCartProductNumber intValue]];

    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedOnEditButtonWithShoppingCartModel:)]) {
        [self.delegate didClickedOnEditButtonWithShoppingCartModel:self.shoppingCartModel];
    }
}

- (IBAction)didClickDeleteButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedOnDeleteButtonWithShoppingCartModel:)]) {
        [self.delegate didClickedOnDeleteButtonWithShoppingCartModel:self.shoppingCartModel];
    }
}

- (IBAction)didClickFinishButtonAction:(id)sender {
    self.subContentView1.hidden = NO;
    self.subContentView2.hidden = YES;
    self.editContentView.hidden = YES;
    self.productTitleLabel.hidden = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedOnDoneButtonWithShoppingCartModel:)]) {
        [self.delegate didClickedOnDoneButtonWithShoppingCartModel:self.shoppingCartModel];
    }
}

@end
