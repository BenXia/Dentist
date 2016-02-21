//
//  AllOrderListVM.m
//  Dentist
//
//  Created by Ben on 2/20/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "AllOrderListVM.h"

@implementation AllOrderListVM

+ (int)getOrderTotalPriceWithProductListModel:(ProductListModel *)productListModel {
    int totalPrice = 0;
    for (ProductListGoodsModel *model in productListModel.productListGoodsArray) {
        totalPrice += [model.productPrice intValue]*[model.productNumber intValue];
    }
    return totalPrice;
}

@end
