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

- (void)setMax:(NSNumber *)max{
    _max = max;
    if (max && max.intValue < self.num) {
        self.num = max.intValue;
    }
}

- (void)setMin:(NSNumber *)min{
    _min = min;
    if (min && min.intValue > self.num) {
        self.num = min.intValue;
    }
}

- (int)num{
    return self.textFiled.text.intValue;
}

- (void)setNum:(int)num{
    if(self.max && num > self.max.intValue){
        num = self.max.intValue;
    }
    if (self.min && num < self.min.intValue) {
        num = self.min.intValue;
    }
    self.textFiled.text = [NSString stringWithFormat:@"%d",num];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(editNumberView:didChangeNum:)]) {
        [self.delegate editNumberView:self didChangeNum:num];
    }
}

-(void)didClickMinusButton{
    self.num = self.num - 1;
}

-(void)didClickAddButton{
    self.num = self.num + 1;
}


@end
