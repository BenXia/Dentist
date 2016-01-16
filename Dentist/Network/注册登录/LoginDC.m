//
//  LoginDC.m
//  Dentist
//
//  Created by 王涛 on 16/1/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "LoginDC.h"
#import "UserInfoModel.h"

@implementation LoginDC

- (NSDictionary *)requestURLArgs {
    return @{@"method":@"user.login",@"v":@"0.0.1"};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

- (NSDictionary *)requestHTTPBody {
    if (!self.mobile || !self.password) {
        return nil;
    }
    
    return @{@"mobile" : self.mobile,@"password":self.password};
}

- (BOOL)parseContent:(NSString *)content {

    BOOL result = NO;
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        if ([[resultDict objectForKey:@"code"] intValue] == 200) {
            [self saveUserInfo:resultDict];
            self.loginSuccess = YES;
        } else {
            self.loginSuccess = NO;
        }
        
        result = YES;
    }
    
    return result;
}

- (void)saveUserInfo:(NSDictionary *)resultDict {
    NSDictionary *userDict = [resultDict objectForKey:@"user"];
    [[Cache sharedCache] setToken:[resultDict objectForKey:@"auth"]];
    [[Cache sharedCache] setUserIDString:[userDict objectForKey:@"uid"]];
    [[Cache sharedCache] setUsername:[userDict objectForKey:@"mobile"] password:self.password];
    [[Cache sharedCache] setNickname:[userDict objectForKey:@"nickname"]];
    [UserInfoModel sharedUserInfoModel].nickName = [userDict objectForKey:@"nickname"];
    [UserInfoModel sharedUserInfoModel].headPath = [userDict objectForKey:@"avator"];
    [UserInfoModel sharedUserInfoModel].vipLevel = [userDict objectForKey:@"vip_level"];
    [UserInfoModel sharedUserInfoModel].mobile = [userDict objectForKey:@"mobile"];
  
}

@end
