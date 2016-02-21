//
//  AddFavoriteDC.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/21.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "AddFavoriteDC.h"

@implementation AddFavoriteDC

- (NSDictionary *)requestURLArgs {
    return @{@"method":@"item.favorite_add",@"auth":[UserCache sharedUserCache].token};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

-(NSDictionary*)requestHTTPBody{
    return @{@"iid[]":self.productIds};
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    
    NSLog(@"添加收藏响应数据：%@",content);
    
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
