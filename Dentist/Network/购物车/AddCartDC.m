//
//  AddCartDC.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/21.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "AddCartDC.h"

@implementation AddCartDC

- (NSDictionary *)requestURLArgs {
    return @{@"method":@"order.cart_add",@"auth":[UserCache sharedUserCache].token};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

-(NSDictionary*)requestHTTPBody{
    return @{@"iid[]":self.productIds,@"cart_num[]":self.cartNums};
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    
    NSLog(@"添加购物车响应数据：%@",content);
    
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        NSNumber* code = [resultDict objectForKey:@"code"];
        self.code = code.intValue;
        self.message = [resultDict objectForKey:@"message"];
        result = YES;
    }
    
    return result;
}

@end
