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
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *time_expire;
@property (nonatomic, strong) NSString *time_start;
@property (nonatomic, strong) NSDictionary *weixinDict;

@property (nonatomic, strong) NSString *totalFee;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *outTradeNumberId;

//weixin =     {
//    appid = wx983825eaeef912b7;
//    "mch_id" = 1292687201;
//    "nonce_str" = NBe6LOSEsxxMSLDy;
//    "prepay_id" = wx20160227000908562ac409430006092890;
//    "result_code" = SUCCESS;
//    "return_code" = SUCCESS;
//    "return_msg" = OK;
//    sign = 6BCA9F2B2BBA86A3187EEA1AE45FDE13;
//    "trade_type" = APP;
//};

@end
