//
//  TodayIntroduceCell.m
//  Dentist
//
//  Created by 王涛 on 16/2/3.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "TodayIntroduceCell.h"

@interface TodayIntroduceCell ()
@property (weak, nonatomic) IBOutlet UIView *leftBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageShowImageView;

@property (nonatomic, strong) ProductIntroduceModel *firstModel;
@property (nonatomic, strong) ProductIntroduceModel *secondModel;
@property (nonatomic, strong) ProductIntroduceModel *thirdModel;
@property (nonatomic, strong) ProductIntroduceModel *fourthModel;
@property (nonatomic, strong) ProductIntroduceModel *leftModel;
@end

@implementation TodayIntroduceCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = [g_commonConfig backGroundGrayColor];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProductImage:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProductImage:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProductImage:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProductImage:)];
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProductImage:)];
    [self.firstImageView addGestureRecognizer:tap1];
    [self.secondImageView addGestureRecognizer:tap2];
    [self.thirdImageView addGestureRecognizer:tap3];
    [self.fourthImageView addGestureRecognizer:tap4];
    [self.leftImageShowImageView addGestureRecognizer:tap5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellModel:(id)cellModel {
    _cellModel = cellModel;
    for (ProductIntroduceModel *model in cellModel) {
        if ([model.location isEqualToString:@"中上"]) {
            self.firstModel = model;
            [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]placeholderImage:[UIImage imageNamed:@"网络不给力-03.jpg"]];
        } else if ([model.location isEqualToString:@"右上"]) {
            self.secondModel = model;
            [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"网络不给力-03.jpg"]];
        } else if ([model.location isEqualToString:@"中下"]) {
            self.thirdModel = model;
            [self.thirdImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"网络不给力-03.jpg"]];
        } else if ([model.location isEqualToString:@"右下"]) {
            self.fourthModel = model;
            [self.fourthImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"网络不给力-03.jpg"]];
        } else if ([model.location isEqualToString:@"左"]) {
            self.leftModel = model;
            [self.leftImageShowImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]placeholderImage:[UIImage imageNamed:@"网络不给力-01.jpg"]];
        }
    }
}

#pragma mark - UI Action

- (void) onProductImage:(UITapGestureRecognizer *)tap {
    if (tap.view == self.firstImageView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(todayIntroduceCell:toProductDetailWith:)]) {
            [self.delegate todayIntroduceCell:self toProductDetailWith:self.firstModel.iid];
        }
    } else if (tap.view == self.secondImageView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(todayIntroduceCell:toProductDetailWith:)]) {
            [self.delegate todayIntroduceCell:self toProductDetailWith:self.secondModel.iid];
        }
    } else if (tap.view == self.thirdImageView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(todayIntroduceCell:toProductDetailWith:)]) {
            [self.delegate todayIntroduceCell:self toProductDetailWith:self.thirdModel.iid];
        }
    } else if (tap.view == self.fourthImageView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(todayIntroduceCell:toProductDetailWith:)]) {
            [self.delegate todayIntroduceCell:self toProductDetailWith:self.fourthModel.iid];
        }
    } else if (tap.view == self.leftImageShowImageView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(todayIntroduceCell:toProductDetailWith:)]) {
            [self.delegate todayIntroduceCell:self toProductDetailWith:self.leftModel.iid];
        }
    }
}


@end
