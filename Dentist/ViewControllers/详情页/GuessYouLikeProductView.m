//
//  GuessYouLikeProductView.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "GuessYouLikeProductView.h"

#define kHeightOfPriceLabel 15

@implementation GuessYouLikeProductView

-(instancetype)initWithFrame:(CGRect)frame{
    NSAssert(frame.size.height > frame.size.width, @"GroupProductView高应比宽大");
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitWithFrame:frame];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGRect frame = CGRectMake(0, 0, 60, 100);
        [self commonInitWithFrame:frame];
        
        //约束布局
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.leading.equalTo(self.mas_leading);
            make.trailing.equalTo(self.mas_trailing);
            make.height.equalTo(_imageView.mas_width);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.trailing.equalTo(self.mas_trailing);
            make.bottom.equalTo(self.mas_bottom);
            make.top.equalTo(_imageView.mas_bottom);
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_imageView.mas_leading).with.offset(1);
            make.trailing.equalTo(_imageView.mas_trailing).with.offset(-1);
            make.bottom.equalTo(_imageView.mas_bottom).with.offset(-1);
            make.height.mas_equalTo(kHeightOfPriceLabel);
        }];
        
    }
    return self;
}

-(void)commonInitWithFrame:(CGRect)frame{
    self.backgroundColor = [UIColor clearColor];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
    [_imageView setBorderWidth:1];
    [_imageView setBorderColor:[UIColor lineGray001Color]];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height - kHeightOfPriceLabel , frame.size.width, kHeightOfPriceLabel)];
    _priceLabel.textColor = [UIColor redColor];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.lineBreakMode = NSLineBreakByClipping;
    _priceLabel.font = [UIFont systemFontOfSize:10];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.width
                                                           , frame.size.width, frame.size.height - frame.size.width - kHeightOfPriceLabel)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor fontGray005Color];
    _titleLabel.font = [UIFont systemFontOfSize:10];
    _titleLabel.numberOfLines = 0;
    
    [self addSubview:_imageView];
    [self addSubview:_titleLabel];
    [self addSubview:_priceLabel];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImageView)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

-(void)didClickImageView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(guessYouLikeProductView:didClickProduct:)]) {
        [self.delegate guessYouLikeProductView:self didClickProduct:self.model];
    }
}

@end
