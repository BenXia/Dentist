//
//  ProductAppraiseDC.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/26.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "ProductAppraiseDC.h"

@implementation ProductAppraiseDC

- (NSDictionary *)requestURLArgs {
    NSString* token = [UserCache sharedUserCache].token ? [UserCache sharedUserCache].token : @"";
    return @{@"method":@"order.score",@"auth":token};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

-(NSDictionary*)requestHTTPBodyPlainJsonParams{
    NSMutableDictionary* paramDic = [NSMutableDictionary new];
    [paramDic setObject:self.oid forKey:@"oid"];
    [paramDic setObject:self.iid forKey:@"iid[]"];
    [paramDic setObject:self.score forKey:@"score[]"];
    [paramDic setObject:self.content forKey:@"content[]"];
    
    if (self.imgs && self.imgs.count > 0) {
        [paramDic setObject:self.imgs forKey:@"imgs[]"];
    }
    
    return paramDic;
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    
    NSLog(@"发布商品评论响应数据：%@",content);
    
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        NSNumber* code = [resultDict objectForKey:@"code"];
        NSString* message = [resultDict objectForKey:@"msg"];
        if (code && code.intValue == 200) {
            self.appraiseSuccess = YES;
        }else{
            self.appraiseSuccess = NO;
            NSLog(@"发布商品评论响应码:%d 消息:%@",code.intValue,message);
        }
        
        result = YES;
    }
    
    return result;
}


@end
