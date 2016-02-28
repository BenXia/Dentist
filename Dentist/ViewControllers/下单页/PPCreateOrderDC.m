//
//  PPCreateOrderDC.m
//  Dentist
//
//  Created by Ben on 16/2/26.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPCreateOrderDC.h"

@implementation PPCreateOrderDC

- (NSDictionary *)requestURLArgs {
    return @{@"method":@"order.create", @"v":@"0.0.1", @"auth":[UserCache sharedUserCache].token};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

- (void)requestWillStart {
    [super requestWillStart];
    
    self.responseMsg = @"";
}

- (NSDictionary *)requestHTTPBody {
    if (self.groupIds) {
        NSString *mainProductIds = ((OrderItemModel *)[self.productItemsArray objectAtIndex:0]).productId;
        
        return @{@"iid":mainProductIds,
                 @"pgp_id": self.groupIds,
                 @"order_express":self.orderExpress,
                 @"aid":self.aid,
                 @"pay":self.payType,
                 //@"order_cert[]":self.orderCertArray,
                 @"piao_type":self.piaoType,
                 @"piao_title":self.piaoTitle,
                 @"piao_content":self.piaoContent,
                 @"remark_num":self.remarkNum
                 };
    } else {
        NSMutableArray *idsArray = [NSMutableArray array];
        NSMutableArray *numsArray = [NSMutableArray array];
        
        for (OrderItemModel *model in self.productItemsArray) {
            [idsArray addObject:model.productId];
            [numsArray addObject:[NSString stringWithFormat:@"%d", model.buyNum]];
        }
        
        return @{@"iid[]":idsArray,
                 @"cart_num[]":numsArray,
                 @"order_express":self.orderExpress,
                 @"aid":self.aid,
                 @"pay":self.payType,
                 //@"order_cert[]":self.orderCertArray,
                 @"piao_type":self.piaoType,
                 @"piao_title":self.piaoTitle,
                 @"piao_content":self.piaoContent,
                 @"remark_num":self.remarkNum
                 };
    }
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    NSError *error = nil;
    NSDictionary *resultdict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultdict isKindOfClass:[NSDictionary class]]) {
        self.responseCode = [[resultdict objectForKey:@"code"] intValue];
        self.responseMsg = [resultdict objectForKey:@"msg"];
        
        if (self.responseCode != 200) {
            return NO;
        }

        self.oid = [resultdict objectForKey:@"oid"];
        self.time_expire = [resultdict objectForKey:@"time_expire"];
        self.time_start = [resultdict objectForKey:@"time_start"];
        self.money = [resultdict objectForKey:@"money"];
        self.weixinDict = [resultdict objectForKey:@"weixin"];
        
        self.outTradeNumberId = [resultdict objectForKey:@"out_trade_no"];
        self.totalFee = [resultdict objectForKey:@"total_fee"];
        self.subject = [resultdict objectForKey:@"subject"];
        self.body = [resultdict objectForKey:@"body"];
        
        result = YES;
    }
    
    return result;
}

@end
