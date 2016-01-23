//
//  UserInfoModel.m
//  Dentist
//
//  Created by 王涛 on 16/1/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
SINGLETON_GCD(UserInfoModel);
- (void)cleanWhenLogOut {
    self.mobile = nil;
    self.nickName = nil;
    self.headPath = nil;
    self.vipLevel = nil;
}
@end
