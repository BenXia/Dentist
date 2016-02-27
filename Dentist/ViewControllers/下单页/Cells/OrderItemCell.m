//
//  OrderItemCell.m
//  Dentist
//
//  Created by Ben on 16/2/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "OrderItemCell.h"

@interface OrderItemCell ()

@end

@implementation OrderItemCell

- (void)awakeFromNib {
    // Initialization code
    
    self.productTitleLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
