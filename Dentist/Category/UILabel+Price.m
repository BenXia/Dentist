//
//  UILabel+Price.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "UILabel+Price.h"

@implementation UILabel (Price)

-(void)themeWithPrice:(double)price bigFont:(CGFloat)bigFont smallFont:(CGFloat)smallFont{
    UILabel* label = self;
    label.font = [UIFont systemFontOfSize:smallFont];
    NSString* bigStr = [NSString stringWithFormat:@"%.0f",price];
    NSString* allStr = [NSString stringWithFormat:@"%@%.2f",kYuanSymbolStr,price];
    NSRange bigRange = [allStr rangeOfString:bigStr];
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:bigFont]} range:bigRange];
    label.attributedText = attStr;
}

@end
