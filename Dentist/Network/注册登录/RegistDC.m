//
//  RegistDC.m
//  Dentist
//
//  Created by 王涛 on 16/1/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "RegistDC.h"

@implementation RegistDC
- (NSDictionary *)requestURLArgs {
    return @{@"method":@"user.reg",@"v":@"0.0.1"};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

- (NSDictionary *)requestHTTPBody {
    if (!self.mobile || !self.password || !self.code) {
        return nil;
    }
    
    return @{@"mobile" : self.mobile,@"password":self.password,@"code":self.code};
}

- (BOOL)parseContent:(NSString *)content {
    
    BOOL result = NO;
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        self.responseCode = [[resultDict objectForKey:@"code"] intValue];
        self.responseMsg = [resultDict objectForKey:@"msg"];
        result = YES;
    }
    
    return result;
}

@end
