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
    return RequestMethodPOST;
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
        self.name = [resultDict objectForKey:@"name"];
        self.start_time = [[resultDict objectForKey:@"start_time"] doubleValue];
        self.end_time = [[resultDict objectForKey:@"end_time"] doubleValue];
        for (NSDictionary *dict in [resultDict objectForKey:@"content"]) {
            ProductIntroduceModel *model = [[ProductIntroduceModel alloc] init];
            model.img_url = [dict objectForKey:@"img_url"];
            model.iid = [dict objectForKey:@"iid"];
            [self.productArray addObject:model];
        }
        result = YES;
    }
    
    return result;
}
@end
