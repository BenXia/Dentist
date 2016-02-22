//
//  MyFavoriteDC.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "MyFavoriteDC.h"

const int kPageSize = 10;

@implementation MyFavoriteDC

- (NSDictionary *)requestURLArgs {
    if (self.next_iid) {
        return @{@"method":@"item.favorite_list",@"pagesize":@(kPageSize),@"next_iid":self.next_iid};
    }else{
        return @{@"method":@"item.favorite_list",@"pagesize":@(kPageSize)};
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
        
        self.total_num = [resultDict objectForKey:@"total_num"];
        self.next_iid = [resultDict objectForKey:@"next_iid"];
        
        
        NSArray* products = [resultDict objectForKey:@"products"];
        self.products = [NSMutableArray new];
        for (NSDictionary* itemDic in products) {
            FavoriteProductModel* item = [FavoriteProductModel new];
            item.iid = [itemDic objectForKey:@"iid"];
            item.title = [itemDic objectForKey:@"title"];
            item.img_url = [itemDic objectForKey:@"img_url"];
            item.price = [itemDic objectForKey:@"price"];

            [self.products addObject:item];
        }
        
        
        result = YES;
    }
    
    return result;
}

@end
