//
//  PPCreateOrderDC.h
//  Dentist
//
//  Created by Ben on 16/2/26.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"
#import "OrderItemModel.h"

@interface PPCreateOrderDC : PPDataController

@property (nonatomic, strong) NSString *groupIds;
@property (nonatomic, strong) NSMutableArray *productItemsArray;

@property (nonatomic, strong) NSString *orderExpress;
@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *payType;

// 非必选字段
@property (nonatomic, strong) NSArray *orderCertArray;
@property (nonatomic, strong) NSString *piaoType;
@property (nonatomic, strong) NSString *piaoTitle;
@property (nonatomic, strong) NSString *piaoContent;
@property (nonatomic, strong) NSString *remarkNum;


//output
@property (nonatomic, assign) int responseCode;
@property (nonatomic, strong) NSString *responseMsg;
@property (nonatomic, strong) NSString *oid;
@property (nonatomic, strong) NSDictionary *weixinDict;
@property (nonatomic, strong) NSDictionary *alipayDict;

@end
