//
//  MyFavoriteDC.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "MyFavoriteDC.h"

static const int kPageSize = 10;

@implementation MyFavoriteDC

- (NSDictionary *)requestURLArgs {
    NSString* token = [UserCache sharedUserCache].token ? [UserCache sharedUserCache].token : @"";
    if (self.next_iid) {
        return @{@"method":@"item.favorite_list",@"pagesize":@(kPageSize),@"next_iid":self.next_iid,@"auth":token};
    }else{
        return @{@"method":@"item.favorite_list",@"pagesize":@(kPageSize),@"auth":token};
    }
}

- (RequestMethod)requestMethod {
    return RequestMethodGET;
}

-(NSDictionary*)requestHTTPBody{
    return nil;
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    
    NSLog(@"收藏列表响应数据：%@",content);
    
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        
        NSArray* products = [resultDict objectForKey:@"products"];
        NSMutableArray* tmpArray = [NSMutableArray new];
        for (NSDictionary* itemDic in products) {
            FavoriteProductModel* item = [FavoriteProductModel new];
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
            NSLog(@"获取收藏响应码:%d 消息:%@",code.intValue,message);
        }
        
        result = YES;
    }
    
    return result;
}

@end
