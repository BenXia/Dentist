//
//  EditNumberView.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/20.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "EditNumberView.h"

@interface EditNumberView ()

@property (strong,nonatomic) UIButton* minusButton;
@property (strong,nonatomic) UIButton* addButton;
@property (strong,nonatomic) UITextField* textFiled;

@property (assign,nonatomic) NSNumber* max;
@property (assign,nonatomic) NSNumber* min;

@end

@implementation EditNumberView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    self.minusButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.minusButton setImage:[UIImage imageNamed:@"btn_numberminus72_default"] forState:UIControlStateNormal];
    [self.minusButton setImage:[UIImage imageNamed:@"btn_numberminus72_pressed"] forState:UIControlStateHighlighted];
    [self.minusButton addTarget:self action:@selector(didClickMinusButton) forControlEvents:UIControlEventTouchUpInside];
    [self.minusButton setBorderColor:[UIColor lightGrayColor]];
    [self.minusButton setBorderWidth:1];
    
    self.textFiled = [[UITextField alloc]initWithFrame:CGRectMake(30, 9, 40, 30)];
    self.textFiled.text = @"0";
    self.textFiled.userInteractionEnabled = NO;
    self.textFiled.textAlignment = NSTextAlignmentCenter;
    [self.textFiled setBorderColor:[UIColor lightGrayColor]];
    [self.textFiled setBorderWidth:1];
    
    self.addButton = [[UIButton alloc]initWithFrame:CGRectMake(70, 0, 30, 30)];
    [self.addButton setImage:[UIImage imageNamed:@"btn_numberplus72_default"] forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"btn_numberplus72_pressed"] forState:UIControlStateHighlighted];
    [self.addButton addTarget:self action:@selector(didClickAddButton) forControlEvents:UIControlEventTouchUpInside];
    [self.addButton setBorderColor:[UIColor lightGrayColor]];
    [self.addButton setBorderWidth:1];
    
    [self addSubview:self.minusButton];
    [self addSubview:self.textFiled];
    [self addSubview:self.addButton];
    
    
    [self.minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(self.minusButton.mas_height);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(self.minusButton.mas_height);
    }];
    
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.minusButton.mas_trailing);
        make.trailing.equalTo(self.addButton.mas_leading);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

-(void)resetWithMin:(NSNumber*)min max:(NSNumber*)max default:(NSNumber*)def{
    self.min = min;
    self.max = max;
    if (def) {
        self.textFiled.text = [NSString stringWithFormat:@"%d",def.intValue];
    }
}

-(void)didClickMinusButton{
    int num = self.textFiled.text.intValue;
    if (!self.min || num > self.min.intValue) {
        num --;
        self.textFiled.text = [NSString stringWithFormat:@"%d",num];
        if (self.delegate && [self.delegate respondsToSelector:@selector(editNumberView:didMinusNum:)]) {
            [self.delegate editNumberView:self didMinusNum:num];
        }
    }
}

-(void)didClickAddButton{
    int num = self.textFiled.text.intValue;
    if (!self.max || num < self.max.intValue) {
        num ++;
        self.textFiled.text = [NSString stringWithFormat:@"%d",num];
        if (self.delegate && [self.delegate respondsToSelector:@selector(editNumberView:didAddNum:)]) {
            [self.delegate editNumberView:self didAddNum:num];
        }
    }
}


@end
