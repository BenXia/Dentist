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
@property (weak, nonatomic) IBOutlet UILabel *firstItemNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstSalePriceBtn;
@property (weak, nonatomic) IBOutlet UIImageView *firstItemImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondItemImageView;
@property (weak, nonatomic) IBOutlet UILabel *secondItemNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *secondtSalePriceBtn;
@property (weak, nonatomic) IBOutlet UILabel *secondItemPriceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *thirdItemImageView;
@property (weak, nonatomic) IBOutlet UILabel *thirdItemNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *thirdSalePriceBtn;
@property (weak, nonatomic) IBOutlet UILabel *thirdItemPriceLabel;
@end

@implementation SaleActivityCell

- (void)awakeFromNib {
    // Initialization code
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
            [self.firstItemImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:nil];
        } else if (i == 1) {
            [self.secondItemImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:nil];
        } else if (i == 2) {
            [self.thirdItemImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:nil];
        }
        
    }
}

@end
