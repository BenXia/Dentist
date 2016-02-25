//
//  OrderBottomInfoCell.m
//  Dentist
//
//  Created by Ben on 16/2/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "OrderBottomInfoCell.h"

@interface OrderBottomInfoCell ()

@property (weak, nonatomic) IBOutlet UIView *topContentView;
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;

@property (weak, nonatomic) IBOutlet UIImageView *certificateImageView;
@property (weak, nonatomic) IBOutlet UILabel *certificateLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketInfoLabel;
@property (weak, nonatomic) IBOutlet UITextField *feedbackTextField;

@property (weak, nonatomic) IBOutlet UIImageView *payTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;

@end

@implementation OrderBottomInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.feedbackTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextField Related

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.feedbackTextField) {
        NSLog (@"textField.text: %@", self.feedbackTextField.text);
    }
}

#pragma mark - IBActions

- (IBAction)didClickCertificateButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCertificateButton)]) {
        [self.delegate didClickCertificateButton];
    }
}

- (IBAction)didClickDeliverButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickDeliverButton)]) {
        [self.delegate didClickDeliverButton];
    }
}

- (IBAction)didClickTicketButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickTicketButton)]) {
        [self.delegate didClickTicketButton];
    }
}

- (IBAction)didClickPayTypeButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickPayTypeButton)]) {
        [self.delegate didClickPayTypeButton];
    }
}

@end
