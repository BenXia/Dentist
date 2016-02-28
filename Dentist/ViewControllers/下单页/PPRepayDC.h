//
//  PPRepayDC.h
//  Dentist
//
//  Created by Ben on 16/2/27.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface PPRepayDC : PPDataController

@property (nonatomic, strong) NSString *oid;
@property (nonatomic, strong) NSString *payType;

//output
@property (nonatomic, assign) int responseCode;
@property (nonatomic, strong) NSString *responseMsg;
@property (nonatomic, strong) NSString *orderNumberId;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *time_expire;
@property (nonatomic, strong) NSString *time_start;
@property (nonatomic, strong) NSDictionary *weixinDict;

@property (nonatomic, strong) NSString *totalFee;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *outTradeNumberId;

@end
