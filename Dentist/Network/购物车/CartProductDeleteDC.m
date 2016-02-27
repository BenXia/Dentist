//
//  CartProductDeleteDC.m
//  Dentist
//
//  Created by Ben on 2/24/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "CartProductDeleteDC.h"

@implementation CartProductDeleteDC

- (NSDictionary *)requestURLArgs {
    NSString* token = [UserCache sharedUserCache].token ? [UserCache sharedUserCache].token : @"";
    return @{@"method":@"order.cart_del",@"method":@"0.0.1",@"auth":token};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

-(NSDictionary*)requestHTTPBody{
    return @{@"iid[]":self.productIdArray};
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    
    NSLog(@"购物车商品数量响应数据：%@",content);
    
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        self.code = [resultDict objectForKey:@"code"];
        if (self.code.intValue == 200) {
            result = YES;
        }
    }
    
    return result;
}

@end
