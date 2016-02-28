//
//  AllOrderListVM.h
//  Dentist
//
//  Created by Ben on 2/20/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductListModel.h"
#import "ProductListGoodsModel.h"
#import "OrderListDC.h"
#import "DeleteOrderDC.h"

@interface AllOrderListVM : NSObject

@property (strong, nonatomic) OrderListDC        *orderListDC;
@property (strong, nonatomic) DeleteOrderDC      *deleteOrderDC;
@property (assign, nonatomic) OrderStatusType     orderStatusType;

@property (strong, nonatomic) ProductListModel   *model; //需要删除的model


+ (float)getOrderTotalPriceWithProductListModel:(ProductListModel *)productListModel;

- (void)filterDataWithOrderStatusType;
@end
