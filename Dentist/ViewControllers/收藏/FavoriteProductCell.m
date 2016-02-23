//
//  FavoriteProductCell.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "FavoriteProductCell.h"
#import "FavoriteProductModel.h"

@interface FavoriteProductCell ()
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation FavoriteProductCell

- (void)awakeFromNib {
    // Initialization code
    [self setBorderWidth:1];
    
    [[RACObserve(self, selected) takeUntil:self.rac_prepareForReuseSignal]subscribeNext:^(NSNumber* x) {
        self.selectButton.selected = x.boolValue;
        if (x.boolValue) {
            [self setBorderColor:[UIColor themeCyanColor]];
        }else{
            [self setBorderColor:[UIColor clearColor]];
        }
    }];
}

-(void)setModel:(id)model{
    if ([model isKindOfClass:[FavoriteProductModel class]]) {
        FavoriteProductModel* favoriteModel = model;
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:favoriteModel.img_url]];
        self.productTitleLabel.text = favoriteModel.title;
        [self.priceLabel themeWithPrice:favoriteModel.price.doubleValue bigFont:14 smallFont:12];
    }
}

@end
