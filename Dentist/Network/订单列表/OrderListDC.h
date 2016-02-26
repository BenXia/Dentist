//
//  OrderListDC.h
//  Dentist
//
//  Created by Ben on 2/21/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPDataController.h"

@interface OrderListDC : PPDataController

@property (nonatomic, strong) NSNumber *next_iid;     //下一页id，用于分页获取数据
@property (nonatomic, strong) NSString *pagesize;     //
@property (nonatomic, strong) NSString *status;       //
@property (nonatomic, strong) NSMutableArray *orderListArray;    //订单列表数组

@end
