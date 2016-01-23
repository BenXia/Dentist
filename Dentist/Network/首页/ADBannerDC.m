//
//  ADBannerDC.m
//  Dentist
//
//  Created by 王涛 on 16/1/23.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "ADBannerDC.h"
#import "BannerModel.h"

@implementation ADBannerDC

- (NSDictionary *)requestURLArgs {
    return @{@"method":@"item.category",@"v":@"0.0.1"};
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
    NSDictionary *resultdict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultdict isKindOfClass:[NSDictionary class]]) {
        [self transModel:resultdict];
        result = YES;
    }
    
    return result;
}

- (void)transModel:(NSDictionary *)resultDict {
    self.bannerArr = [NSMutableArray array];
    for (NSDictionary *dict in [resultDict objectForKey:@"categorys"]) {
        for (NSDictionary *dict2 in [dict objectForKey:@"sub"]) {
            [self.bannerArr addObject:[BannerModel modelWithDict:dict2]];
        }
        
    }
}

@end
