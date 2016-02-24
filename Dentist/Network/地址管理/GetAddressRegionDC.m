//
//  GetAddressRegionDC.m
//  Dentist
//
//  Created by 王涛 on 16/2/24.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "GetAddressRegionDC.h"

@implementation GetAddressRegionDC
- (NSDictionary *)requestURLArgs {
    return @{@"method":@"address.region_app",@"v":@"0.0.1"};
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
    NSArray *resultArr = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultArr isKindOfClass:[NSArray class]]) {
        self.provinceArray = resultArr;
        result = YES;
    }
    
    return result;
}

- (NSArray *)provinceArray {
    if (!_provinceArray) {
        _provinceArray = [NSArray array];
    }
    return _provinceArray;
}

@end
