//
//  MyOrderCell.m
//  Dentist
//
//  Created by 王涛 on 16/2/4.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "MyOrderCell.h"

@interface MyOrderCell ()
@property (weak, nonatomic) IBOutlet UIButton *waitingDoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitingApprise;
@property (weak, nonatomic) IBOutlet UIButton *alreadDoneBtn;

@end

@implementation MyOrderCell

- (void)awakeFromNib {
    [self.waitingDoneBtn centerImageAndTitle];
    [self.waitingApprise centerImageAndTitle];
    [self.alreadDoneBtn centerImageAndTitle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)orderWaitingButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderButtonClickedWithType:)]) {
        [self.delegate orderButtonClickedWithType:OrderHandle_WaitingPay];
    }
}

- (IBAction)orderWaitingPraiseButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderButtonClickedWithType:)]) {
        [self.delegate orderButtonClickedWithType:OrderHandle_WaitingPraise];
    }
}

- (IBAction)orderHaveDoneButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderButtonClickedWithType:)]) {
        [self.delegate orderButtonClickedWithType:OrderHandle_Done];
    }
}
@end
