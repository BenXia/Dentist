//
//  GetLookHistoryDC.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/23.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "GetLookHistoryDC.h"

static const int kPageSize = 10;

@implementation GetLookHistoryDC

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
    
    NSLog(@"浏览记录响应数据：%@",content);
    
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        
        NSArray* products = [resultDict objectForKey:@"products"];
        NSMutableArray* tmpArray = [NSMutableArray new];
        for (NSDictionary* itemDic in products) {
            HistoryProductModel* item = [FavoriteProductModel new];
            item.iid = [itemDic objectForKey:@"iid"];
            item.title = [itemDic objectForKey:@"title"];
            item.img_url = [itemDic objectForKey:@"img_url"];
            item.price = [itemDic objectForKey:@"price"];
            
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

        
        
        result = YES;
    }
    
    return result;
}


@end
