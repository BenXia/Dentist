//
//  SaleActivityCell.m
//  Dentist
//
//  Created by 王涛 on 16/2/4.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "SaleActivityCell.h"

@interface SaleActivityCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *firstItemImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondItemImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdItemImageView;

@property (nonatomic, strong) ProductIntroduceModel *firstModel;
@property (nonatomic, strong) ProductIntroduceModel *secondModel;
@property (nonatomic, strong) ProductIntroduceModel *thirdModel;
@property (nonatomic, strong) ProductIntroduceModel *bannerModel;
@end

@implementation SaleActivityCell

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProductImage:)];
    [self.firstItemImageView addGestureRecognizer:tap];
    [self.secondItemImageView addGestureRecognizer:tap];
    [self.thirdItemImageView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellModelArray:(NSArray *)cellModelArray {
    _cellModelArray = cellModelArray;
    
    for (ProductIntroduceModel *model in cellModelArray) {
        if ([model.location isEqualToString:@"左1"]) {
            self.firstModel = model;
            [self.firstItemImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]placeholderImage:[UIImage imageNamed:@"test.png"]];
        } else if ([model.location isEqualToString:@"右1"]) {
            self.secondModel = model;
            [self.secondItemImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"test.png"]];
        } else if ([model.location isEqualToString:@"右2"]) {
            self.thirdModel = model;
            [self.thirdItemImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"test.png"]];
        } else if ([model.location isEqualToString:@"banner"]) {
            self.bannerModel = model;
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"test.png"]];
        }
    }
}

#pragma mark - UI Action

- (void) onProductImage:(UITapGestureRecognizer *)tap {
    if (tap.view == self.firstItemImageView) {
        ProductIntroduceModel *model = self.cellModelArray[0];
        if (self.delegate && [self.delegate respondsToSelector:@selector(saleActivityCell:toProductDetailWith:)]) {
            [self.delegate saleActivityCell:self toProductDetailWith:model.iid];
        }
    } else if (tap.view == self.secondItemImageView) {
        ProductIntroduceModel *model = self.cellModelArray[1];
        if (self.delegate && [self.delegate respondsToSelector:@selector(saleActivityCell:toProductDetailWith:)]) {
            [self.delegate saleActivityCell:self toProductDetailWith:model.iid];
        }
    } else if (tap.view == self.thirdItemImageView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(saleActivityCell:toProductDetailWith:)]) {
            ProductIntroduceModel *model = self.cellModelArray[2];
            [self.delegate saleActivityCell:self toProductDetailWith:model.iid];
        }
    }
}

@end
