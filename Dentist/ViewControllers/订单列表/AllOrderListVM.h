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


@interface AllOrderListVM : NSObject

@property (strong, nonatomic) OrderListDC    *orderListDC;


+ (int)getOrderTotalPriceWithProductListModel:(ProductListModel *)productListModel;


@end
