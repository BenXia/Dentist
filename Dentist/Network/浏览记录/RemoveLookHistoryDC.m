//
//  RemoveLookHistoryDC.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "RemoveLookHistoryDC.h"

@implementation RemoveLookHistoryDC

- (NSDictionary *)requestURLArgs {
    NSString* token = [UserCache sharedUserCache].token ? [UserCache sharedUserCache].token : @"";
    return @{@"method":@"item.view_del",@"auth":token};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

-(NSDictionary*)requestHTTPBody{
    return @{@"iid[]":self.productIds};
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    
    NSLog(@"删除浏览记录响应数据：%@",content);
    
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        NSNumber* code = [resultDict objectForKey:@"code"];
        self.code = code.intValue;
        self.message = [resultDict objectForKey:@"msg"];
        
        if (self.code != 200) {
            NSLog(@"删除浏览记录响应码:%d 消息:%@",self.code,self.message);
        }
        
        result = YES;
    }
    
    return result;
}

@end
