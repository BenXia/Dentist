//
//  WTLabel.m
//  core_animation
//
//  Created by 王涛 on 15/4/22.
//  Copyright (c) 2015年 王涛. All rights reserved.
//

#import "WTLabel.h"
#import "UIColor+theme.h"

#define kDefaultHeadImageWidth 42
#define kDefaultHeadImageHeight 42
#define kGap 30
#define kLabel_Width [UIScreen mainScreen].applicationFrame.size.width-kDefaultHeadImageWidth-2*kGap-PIXEL_12

@implementation WTLabel

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit:self.frame];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title andSubTitle:(NSString *)subTitle andButtonTitle:(NSString *)buttonTitle andIcon:(NSString *)img {
    if (self = [super initWithFrame:frame]) {
        [self commonInit:frame];
        [self setTitle:title];
        [self setSubTitle:subTitle];
        [self setButtonTitle:buttonTitle];
        [self setImg:img];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    self.subTitleLabel.text = subTitle;
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    [self.btn setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)setImg:(NSString *)img {
    if (!img || ![img length]) {
        return;
    }
    
    _img = img;
    UIImage *image = [UIImage imageNamed:img];
    [_iconImg setImage:image];
}

- (void)commonInit:(CGRect)frame {
    self.backgroundColor = [UIColor clearColor];
    //icon
    _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(65, 10, kDefaultHeadImageWidth, kDefaultHeadImageHeight)];
    
    //labels
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(118, 10, self.width - 118, 21)];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    
    _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(118, 36, self.width - 118, 18)];
    _subTitleLabel.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0];
    _subTitleLabel.numberOfLines = 0;
    _subTitleLabel.font = [UIFont systemFontOfSize:12];
    
    _btn = [[UIButton alloc] initWithFrame:CGRectMake((self.width - 160) / 2, 90, 160, 35)];
    [_btn addTarget:self action:@selector(didClickOnBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_btn thematized];
    _btn.titleLabel.font = [UIFont systemFontOfSize:16];
    _btn.layer.cornerRadius = 3.f;
    _btn.layer.masksToBounds = YES;
    
    [self addSubview:_iconImg];
    [self addSubview:_titleLabel];
    [self addSubview:_subTitleLabel];
    [self addSubview:_btn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat detailLabelHeight = [self getSubTitleLabelHeight].height;
    _subTitleLabel.height = detailLabelHeight;
    
    CGFloat y = 36 + detailLabelHeight + 41;
    self.btn.y = y;
}

#pragma mark - Utility

- (CGSize)getSubTitleLabelHeight {
    CGSize titleSize = [_subTitleLabel.text boundingRectWithSize:CGSizeMake(self.width - 118, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    
    return titleSize;
}

- (void)didClickOnBtn:(UIButton *)btn {
    [self.delegate didClickOnBtn];
}

@end
