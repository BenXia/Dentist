//
//  ADTodayIntroduceDC.m
//  Dentist
//
//  Created by 王涛 on 16/2/5.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "ADTodayIntroduceDC.h"

@implementation ADTodayIntroduceDC
- (NSDictionary *)requestURLArgs {
    return @{@"method":@"ad.tuijian",@"v":@"0.0.1"};
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
    NSArray *resultArray = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in resultArray) {
            
        }
        result = YES;
    }
    
    return result;
}
@end
