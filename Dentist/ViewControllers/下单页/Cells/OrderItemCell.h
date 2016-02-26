//
//  OrderItemCell.h
//  Dentist
//
//  Created by Ben on 16/2/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet QQingImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCustomiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNumberLabel;

@end
