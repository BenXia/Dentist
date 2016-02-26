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

typedef NS_ENUM(NSInteger,OrderStatusType) {
    OrderStatusType_NeedHandle = 0,
    OrderStatusType_Complete ,
    OrderStatusType_NeedPraise ,
    OrderStatusType_All ,
};

@interface AllOrderListVM : NSObject

@property (strong, nonatomic) OrderListDC        *orderListDC;
@property (assign, nonatomic) OrderStatusType     orderStatusType;


+ (float)getOrderTotalPriceWithProductListModel:(ProductListModel *)productListModel;

- (void)filterDataWithOrderStatusType;
@end
