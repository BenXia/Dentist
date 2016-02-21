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


@interface AllOrderListVM : NSObject

@property (nonatomic, strong) NSMutableArray *orderListArray;    //订单列表数组


+ (int)getOrderTotalPriceWithProductListModel:(ProductListModel *)productListModel;


@end
