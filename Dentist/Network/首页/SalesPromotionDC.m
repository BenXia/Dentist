//
//  SalesPromotionDC.m
//  Dentist
//
//  Created by 王涛 on 16/2/20.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "SalesPromotionDC.h"

@implementation SalesPromotionDC
- (NSDictionary *)requestURLArgs {
    return @{@"method":@"ad.cuxiao",@"v":@"0.0.1"};
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
    NSArray *resultArray = [NSJSONSerialization JSONObjectWithString:content
                                                             options:0
                                                               error:&error];
    if (!error || [resultArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in resultArray) {
            ProductIntroduceModel *model = [[ProductIntroduceModel alloc] init];
            model.location = [dict objectForKey:@"location"];
            model.end_time = [dict objectForKey:@"end_time"];
            model.start_time = [dict objectForKey:@"start_time"];
            model.img_url = [dict objectForKey:@"img_url"];
            model.event_id = [dict objectForKey:@"event_id"];
            model.iid = [dict objectForKey:@"iid"];
            [self.productArray addObject:model];
        }
        result = YES;
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
