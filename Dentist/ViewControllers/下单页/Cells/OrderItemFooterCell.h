//
//  OrderItemFooterCell.h
//  Dentist
//
//  Created by Ben on 16/2/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderItemFooterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderItemsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
