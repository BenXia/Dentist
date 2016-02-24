//
//  ProductEvaluateDC.m
//  Dentist
//
//  Created by Ben on 2/24/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "ProductEvaluateDC.h"

@implementation ProductEvaluateDC

- (NSDictionary *)requestURLArgs {
    return @{@"method":@"",@"v":@"0.0.1",@"iid":self.cartProductId};
}

- (RequestMethod)requestMethod {
    return RequestMethodGET;
}

-(NSDictionary*)requestHTTPBody{
    return @{@"iid[]":self.cartProductId};
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    
    NSLog(@"购物车商品数量响应数据：%@",content);
    
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
