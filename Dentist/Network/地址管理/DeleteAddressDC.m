//
//  DeleteAddressDC.m
//  Dentist
//
//  Created by 王涛 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "DeleteAddressDC.h"

@implementation DeleteAddressDC
- (NSDictionary *)requestURLArgs {
    return @{@"method":@"address.del",@"v":@"0.0.1",@"auth":[UserCache sharedUserCache].token};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

- (NSDictionary *)requestHTTPBody {
    if (!self.aid) {
        return nil;
    }
    return @{@"aid":self.aid};
}

- (BOOL)parseContent:(NSString *)content {
    
    BOOL result = NO;
    NSError *error = nil;
    NSDictionary *resultdict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultdict isKindOfClass:[NSDictionary class]]) {
        self.responseCode = [[resultdict objectForKey:@"code"] intValue];
        self.responseMsg = [resultdict objectForKey:@"msg"];
        result = YES;
    }
    
    return result;
}

@end
