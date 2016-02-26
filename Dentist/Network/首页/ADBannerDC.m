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
    return @{@"method":@"ad.banner",@"v":@"0.0.1"};
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
            [self.bannerArr addObject:[BannerModel modelWithDict:dict]];
        }
        result = YES;
    }
    
    return result;
}

- (NSMutableArray *)bannerArr {
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

@end
