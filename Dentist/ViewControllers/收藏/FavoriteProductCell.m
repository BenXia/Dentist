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
    [self setBorderColor:[UIColor clearColor]];
}

-(void)setModel:(id)model isEditing:(BOOL)isEditing isSelected:(BOOL)isSelected{
    if ([model isKindOfClass:[FavoriteProductModel class]]) {
        FavoriteProductModel* favoriteModel = model;
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:favoriteModel.img_url]];
        self.productTitleLabel.text = favoriteModel.title;
        [self.priceLabel themeWithPrice:favoriteModel.price.doubleValue bigFont:14 smallFont:12];
    }
    
    if (isEditing) {
        self.selectButton.hidden = NO;
        self.selectButton.selected = isSelected;
        if (isSelected) {
            [self setBorderColor:[UIColor themeCyanColor]];
        }else{
            [self setBorderColor:[UIColor clearColor]];
        }
    }else{
        self.selectButton.hidden = YES;
        [self setBorderColor:[UIColor clearColor]];
    }
}

@end
