//
//  TuanGouCell.m
//  Dentist
//
//  Created by 王涛 on 16/2/4.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "TuanGouCell.h"

@interface TuanGouCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;

@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;

@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@property (weak, nonatomic) IBOutlet UIImageView *fourthImageView;


@end

@implementation TuanGouCell

- (void)awakeFromNib {
    self.timeLabel.text = @"还剩99:59:59";
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProductImage:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProductImage:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProductImage:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProductImage:)];
    [self.firstImageView addGestureRecognizer:tap1];
    [self.secondImageView addGestureRecognizer:tap2];
    [self.thirdImageView addGestureRecognizer:tap3];
    [self.fourthImageView addGestureRecognizer:tap4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellModelArray:(NSArray *)cellModelArray {
    _cellModelArray = cellModelArray;
    
    for (int i = 0 ; i< cellModelArray.count; i++) {
        ProductIntroduceModel *model = cellModelArray[i];
        if (i == 0) {
            [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:nil];
        } else if (i == 1) {
            [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:nil];
        } else if (i == 2) {
            [self.thirdImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:nil];
        } else if (i == 3) {
            [self.fourthImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]placeholderImage:nil];
        }
        
    }
    
}

#pragma mark - UI Action

- (void) onProductImage:(UITapGestureRecognizer *)tap {
    if (tap.view == self.firstImageView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tuanGouCell:toProductDetailWith:)]) {
            ProductIntroduceModel *model = self.cellModelArray[0];
            [self.delegate tuanGouCell:self toProductDetailWith:model.iid];
        }
    } else if (tap.view == self.secondImageView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tuanGouCell:toProductDetailWith:)]) {
            ProductIntroduceModel *model = self.cellModelArray[1];
            [self.delegate tuanGouCell:self toProductDetailWith:model.iid];
        }
    } else if (tap.view == self.thirdImageView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tuanGouCell:toProductDetailWith:)]) {
            ProductIntroduceModel *model = self.cellModelArray[2];
            [self.delegate tuanGouCell:self toProductDetailWith:model.iid];
        }
    } else if (tap.view == self.fourthImageView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tuanGouCell:toProductDetailWith:)]) {
            ProductIntroduceModel *model = self.cellModelArray[3];
            [self.delegate tuanGouCell:self toProductDetailWith:model.iid];
        }
    }
}


@end
