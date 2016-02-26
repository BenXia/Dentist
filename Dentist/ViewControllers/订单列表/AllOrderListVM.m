//
//  AllOrderListVM.m
//  Dentist
//
//  Created by Ben on 2/20/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "AllOrderListVM.h"

@implementation AllOrderListVM

+ (float)getOrderTotalPriceWithProductListModel:(ProductListModel *)productListModel {
    float totalPrice = 0;
    for (ProductListGoodsModel *model in productListModel.productListGoodsArray) {
        totalPrice += [model.productPrice floatValue]*[model.productNumber intValue];
    }
    totalPrice += [productListModel.productExpressPrice intValue];
    return totalPrice;
}

- (void)filterDataWithOrderStatusType {
    switch (self.orderStatusType) {
        case OrderStatusType_NeedHandle: {
            NSMutableArray *filterArray = [NSMutableArray new];
            for (ProductListModel *model in self.orderListDC.orderListArray) {
                if ([model.statusCode intValue] == 0 || [model.statusCode intValue] == 1 || [model.statusCode intValue] == 2) {
                    [filterArray addObject:model];
                }
            }
            self.orderListDC.orderListArray = filterArray;
        }
            break;
        case OrderStatusType_Complete: {
            NSMutableArray *filterArray = [NSMutableArray new];
            for (ProductListModel *model in self.orderListDC.orderListArray) {
                if ([model.statusCode intValue] == 4 || [model.statusCode intValue] == 10) {
                    [filterArray addObject:model];
                }
            }
            self.orderListDC.orderListArray = filterArray;
        }
            break;
        case OrderStatusType_NeedPraise: {
            NSMutableArray *filterArray = [NSMutableArray new];
            for (ProductListModel *model in self.orderListDC.orderListArray) {
                if ([model.statusCode intValue] == 3) {
                    [filterArray addObject:model];
                }
            }
            self.orderListDC.orderListArray = filterArray;
        }
            break;
        case OrderStatusType_All: {
            //所有订单不做处理
        }
            break;

        default:
            break;
    }
}

@end
