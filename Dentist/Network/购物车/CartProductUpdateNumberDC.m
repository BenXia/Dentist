//
//  CartProductUpdateNumberDC.m
//  Dentist
//
//  Created by Ben on 2/24/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "CartProductUpdateNumberDC.h"

@implementation CartProductUpdateNumberDC

- (NSDictionary *)requestURLArgs {
    NSString* token = [UserCache sharedUserCache].token ? [UserCache sharedUserCache].token : @"";
    return @{@"method":@"order.cart_change",@"method":@"0.0.1",@"auth":token};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

-(NSDictionary*)requestHTTPBody{
//    NSMutableArray *bodyArray = [NSMutableArray array];
//    for (int index = 0 ; index < self.cartProductIdArray.count;index++) {
//        NSString *idString = [self.cartProductIdArray objectAtIndex:index];
//        NSString *numberString = [self.productNumberArray objectAtIndex:index];
//        [bodyArray addObject:@{@"iid[]":idString,@"cart_num[]":numberString}];
//    }
    return @{@"iid[]":self.cartProductIdArray,@"cart_num[]":self.productNumberArray};
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
