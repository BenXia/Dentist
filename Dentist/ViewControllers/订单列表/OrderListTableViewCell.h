//
//  OrderListTableViewCell.h
//  Dentist
//
//  Created by Ben on 2/20/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductListGoodsModel.h"


@interface OrderListTableViewCell : UITableViewCell

- (void)setModelWithProductListGoodsModel:(ProductListGoodsModel *)productListGoodsModel;

@end
