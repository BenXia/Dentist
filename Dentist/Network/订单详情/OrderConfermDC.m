//
//  OrderConfermDC.m
//  Dentist
//
//  Created by Ben on 2/26/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "OrderConfermDC.h"

@implementation OrderConfermDC

- (NSDictionary *)requestURLArgs {
    NSString* token = [UserCache sharedUserCache].token ? [UserCache sharedUserCache].token : @"";
    return @{@"method":@"order.delivery",@"v":@"0.0.1",@"auth":token};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

-(NSDictionary*)requestHTTPBody{
    return @{@"oid":self.oid};
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    
    NSLog(@"订单确认收货响应数据：%@",content);
    
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        NSNumber* code = [resultDict objectForKey:@"code"];
        if (code.intValue == 200) {
            result = YES;
        }
    }
    
    return result;
}

@end
