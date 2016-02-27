//
//  ProductSearchDC.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/23.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "SearchProductDC.h"

static const int pagesize = 10;

@implementation SearchProductDC

- (NSDictionary *)requestURLArgs {
    NSDictionary* tmpDic = @{@"method":@"item.search",@"v":@"0.0.1",@"pagesize":@(pagesize)};
    NSMutableDictionary* paramDic = [NSMutableDictionary dictionaryWithDictionary:tmpDic];
    if (self.cid) {
        [paramDic setValue:self.cid forKey:@"cid"];
    }
    if (self.s_cid) {
        [paramDic setValue:self.s_cid forKey:@"s_cid"];
    }
    if (self.searchKey) {
        [paramDic setValue:self.searchKey forKey:@"k"];
    }
    if (self.next_iid) {
        [paramDic setValue:self.next_iid forKey:@"next_iid"];
    }
    return paramDic;
}

- (RequestMethod)requestMethod {
    return RequestMethodGET;
}

- (NSDictionary *)requestHTTPBody {
    return nil;
}

- (BOOL)parseContent:(NSString *)content {
    
    NSLog(@"搜索商品响应数据：%@",content);
    
    BOOL result = NO;
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        
        
        NSArray* products = [resultDict objectForKey:@"products"];
        NSMutableArray* tmpArray = [NSMutableArray new];
        for (NSDictionary* itemDic in products) {
            SearchProductModel* item = [SearchProductModel new];
            item.iid = [itemDic objectForKey:@"iid"];
            item.title = [itemDic objectForKey:@"title"];
            item.img_url = [itemDic objectForKey:@"img_url"];
            item.price = [itemDic objectForKey:@"price"];
            
            item.hasGift = ((NSString*)[itemDic objectForKey:@"gifts"]).intValue > 0;
            item.hasFreeSend = ((NSNumber*)[itemDic objectForKey:@"is_baoyou"]).boolValue;
            
            [tmpArray addObject:item];
        }
        if (!self.next_iid) {
            self.products = tmpArray;
        }else{
            if (!self.products) {
                self.products = tmpArray;
            }else{
                [self.products addObjectsFromArray:tmpArray];
            }
        }
        
        self.total_num = [resultDict objectForKey:@"total_num"];
        self.next_iid = [resultDict objectForKey:@"next_iid"];
        
        NSNumber* code = [resultDict objectForKey:@"code"];
        NSString* message = [resultDict objectForKey:@"msg"];
        if (code && code.intValue != 200) {
            NSLog(@"商品搜索响应码:%d 消息:%@",code.intValue,message);
        }
        
        result = YES;
    }
    
    return result;
}

@end
