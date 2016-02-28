//
//  PPRepayDC.m
//  Dentist
//
//  Created by Ben on 16/2/27.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPRepayDC.h"

@implementation PPRepayDC

- (NSDictionary *)requestURLArgs {
    return @{@"method":@"order.repay", @"v":@"0.0.1", @"auth":[UserCache sharedUserCache].token};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

- (void)requestWillStart {
    [super requestWillStart];
    
    self.responseMsg = @"";
}

- (NSDictionary *)requestHTTPBody {
    return @{@"oid":self.oid, @"pay":self.payType};
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
        
        self.orderNumberId = [resultdict objectForKey:@"oid"];
        self.money = [resultdict objectForKey:@"money"];
        self.time_expire = [resultdict objectForKey:@"time_expire"];
        self.time_start = [resultdict objectForKey:@"time_start"];
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
