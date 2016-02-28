//
//  OrderListDC.h
//  Dentist
//
//  Created by Ben on 2/21/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPDataController.h"

typedef NS_ENUM(NSInteger,OrderStatusType) {
    OrderStatusType_NeedHandle = 0,
    OrderStatusType_Complete ,
    OrderStatusType_NeedPraise ,
    OrderStatusType_All ,
};

@interface OrderListDC : PPDataController

@property (nonatomic, strong) NSNumber *next_iid;     //下一页id，用于分页获取数据
@property (nonatomic, strong) NSString *pagesize;     //
@property (assign, nonatomic) OrderStatusType     orderStatusType;
@property (nonatomic, strong) NSMutableArray *orderListArray;    //订单列表数组

@end
