//
//  SetNickDC.m
//  Dentist
//
//  Created by 王涛 on 16/2/21.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "SetNickDC.h"

@implementation SetNickDC
- (NSDictionary *)requestURLArgs {
    return @{@"method":@"user.set_nickname",@"v":@"0.0.1",@"auth":[UserCache sharedUserCache].token};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

- (NSDictionary *)requestHTTPBody {
    if (!self.nick) {
        return nil;
    }
    
    return @{@"nickname" : self.nick};
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
