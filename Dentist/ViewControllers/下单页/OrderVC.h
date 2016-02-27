//
//  OrderVC.h
//  Dentist
//
//  Created by Ben on 16/2/15.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItemModel.h"

@interface OrderVC : BaseViewController

// 下单需要调用的接口
- (void)setProductItemsArray:(NSMutableArray *)productItemsArray;
- (void)setGroupId:(NSString *)groupIds;


// 直接支付需要调用的接口
- (void)setOrderId:(NSString *)orderId;

@end
