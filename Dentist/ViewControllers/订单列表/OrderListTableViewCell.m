//
//  OrderListTableViewCell.m
//  Dentist
//
//  Created by Ben on 2/20/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "OrderListTableViewCell.h"

@interface OrderListTableViewCell()
@property(nonatomic, weak) IBOutlet UIImageView *productImageView;
@property(nonatomic, weak) IBOutlet UILabel     *productTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel     *productColorAndModelLabel;
@property(nonatomic, weak) IBOutlet UILabel     *productPriceLabel;
@property(nonatomic, weak) IBOutlet UILabel     *productNumberLabel;

@end

@implementation OrderListTableViewCell

- (void)awakeFromNib {
    self.productTitleLabel.numberOfLines = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModelWithProductListGoodsModel:(ProductListGoodsModel *)productListGoodsModel {
    self.productTitleLabel.text = productListGoodsModel.productTitle;
    self.productColorAndModelLabel.text = productListGoodsModel.productModel;
    self.productPriceLabel.text = [NSString stringWithFormat:@"¥ %@",productListGoodsModel.productPrice];
    self.productNumberLabel.text = [NSString stringWithFormat:@"x %@",productListGoodsModel.productNumber];
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:productListGoodsModel.productImageUrl]
                             placeholderImage:[UIImage imageNamed:kPlaceholderImageView]];

}
@end
