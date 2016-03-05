//
//  GroupBuyingDC.m
//  Dentist
//
//  Created by 王涛 on 16/2/20.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "GroupBuyingDC.h"

@implementation GroupBuyingDC
- (NSDictionary *)requestURLArgs {
    return @{@"method":@"ad.qianggou",@"v":@"0.0.1"};
}

- (RequestMethod)requestMethod {
    return RequestMethodGET;
}

- (NSDictionary *)requestHTTPBody {
    return nil;
}

- (BOOL)parseContent:(NSString *)content {
    
    BOOL result = NO;
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                             options:0
                                                               error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        NSDictionary *tempDict = [resultDict objectForKey:@"row"];
        if ([[resultDict objectForKey:@"code"] intValue] == 200) {
            self.name = [tempDict objectForKey:@"name"];
            self.start_time = [[tempDict objectForKey:@"start_time"] longLongValue];
            self.end_time = [[tempDict objectForKey:@"end_time"] longLongValue];
            self.has_time = [[tempDict objectForKey:@"has_time"] longLongValue];
            
            for (NSDictionary *dict in [tempDict objectForKey:@"content"]) {
                ProductIntroduceModel *model = [[ProductIntroduceModel alloc] init];
                model.img_url = [dict objectForKey:@"img_url"];
                model.iid = [dict objectForKey:@"iid"];
                [self.productArray addObject:model];
            }
            result = YES;
        }
        
    }
    
    return result;
}

- (NSMutableArray *)productArray {
    if (!_productArray) {
        _productArray = [NSMutableArray array];
    }
    return _productArray;
}

@end
