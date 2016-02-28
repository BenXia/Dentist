//
//  FavoriteProductCell.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "FavoriteProductCell.h"
#import "FavoriteProductModel.h"
#import "SearchProductModel.h"

@interface FavoriteProductCell ()
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *freeSendImageView;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freeSendImageViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftImageViewTrailingConstraint;

@property (assign,nonatomic) CGFloat originFreeSendImageViewTrailingGap;

@end

@implementation FavoriteProductCell

- (void)awakeFromNib {
    // Initialization code
    [self setBorderWidth:1];
    [self setBorderColor:[UIColor clearColor]];
    self.originFreeSendImageViewTrailingGap = self.freeSendImageViewTrailingConstraint.constant;
    self.productTitleLabel.numberOfLines = 0;
}

-(void)prepareForReuse{
    self.freeSendImageViewTrailingConstraint.constant = self.originFreeSendImageViewTrailingGap;
    self.giftImageView.hidden = NO;
    self.freeSendImageView.hidden = NO;
}

-(void)setModel:(id)model isEditing:(BOOL)isEditing isSelected:(BOOL)isSelected{
    BOOL hasFreeSend = YES;
    BOOL hasGift = YES;
    if ([model isKindOfClass:[FavoriteProductModel class]]) {
        FavoriteProductModel* favoriteModel = model;
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:favoriteModel.img_url] placeholderImage:[UIImage imageNamed:kPlaceholderImageView]];
        self.productTitleLabel.text = favoriteModel.title;
        [self.priceLabel themeWithPrice:favoriteModel.price.doubleValue bigFont:14 smallFont:12];
        
        hasGift = favoriteModel.hasGift;
        hasFreeSend = favoriteModel.hasFreeSend;
      
    }else if([model isKindOfClass:[SearchProductModel class]]){
        SearchProductModel* searchModel = model;
        [self.productImageView sd_setImageWithURL:[NSURL URLWithString:searchModel.img_url] placeholderImage:[UIImage imageNamed:kPlaceholderImageView]];
        self.productTitleLabel.text = searchModel.title;
        [self.priceLabel themeWithPrice:searchModel.price.doubleValue bigFont:14 smallFont:12];
        
        hasGift = searchModel.hasGift;
        hasFreeSend = searchModel.hasFreeSend;
    }
    
    if (hasFreeSend && !hasGift) {
        self.freeSendImageViewTrailingConstraint.constant = self.giftImageViewTrailingConstraint.constant;
        self.giftImageView.hidden = YES;
    }else if(!hasFreeSend && hasGift){
        self.freeSendImageView.hidden = YES;
    }else if(!hasFreeSend && !hasGift){
        self.freeSendImageView.hidden = YES;
        self.giftImageView.hidden = YES;
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
