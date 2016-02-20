//
//  UserInfoModel.h
//  Dentist
//
//  Created by 王涛 on 16/1/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
+ (UserInfoModel *)sharedUserInfoModel;
@property (nonatomic ,strong) NSString *mobile;
@property (nonatomic ,strong) NSString *nickName;
@property (nonatomic ,strong) NSString *headPath;
@property (nonatomic ,strong) NSString *vipLevel;
- (void)cleanWhenLogOut;
@end
