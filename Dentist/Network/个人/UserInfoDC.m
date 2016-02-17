//
//  UserInfoDC.m
//  Dentist
//
//  Created by 王涛 on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "UserInfoDC.h"

@implementation PersonModel

@end

@implementation UserInfoDC
- (NSDictionary *)requestURLArgs {
    return @{@"method":@"user.getinfo",@"v":@"0.0.1",@"auth":[[UserCache sharedUserCache] token]};
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
        self.userInfoModel = [[PersonModel alloc] init];
        NSDictionary *userDict = [resultDict objectForKey:@"user"];
        self.userInfoModel.headImagePath = [userDict objectForKey:@"avator"];
        self.userInfoModel.nick = [userDict objectForKey:@"nickname"];
        self.userInfoModel.phoneNum = [userDict objectForKey:@"mobile"];
        result = YES;
    }
    
    return result;
}
@end
