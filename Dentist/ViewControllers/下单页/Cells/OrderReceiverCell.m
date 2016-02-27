//
//  OrderReceiverCell.m
//  Dentist
//
//  Created by Ben on 16/2/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "OrderReceiverCell.h"

@interface OrderReceiverCell ()

@end

@implementation OrderReceiverCell

- (void)awakeFromNib {
    // Initialization code
    
    self.receiverAddressLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightWithAddress:(NSString *)receiverAddress {
    CGSize size = [receiverAddress textSizeWithFont:[UIFont systemFontOfSize:12.0]
                                  constrainedToSize:CGSizeMake(kScreenWidth - 95, MAXFLOAT)
                                      lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat cellHeight = 52 + ((size.height > 15) ? (size.height - 15) : 0);
    return cellHeight;
}

@end
