//
//  UserInfoDC.h
//  Dentist
//
//  Created by 王涛 on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface PersonModel : NSObject
@property (strong, nonatomic) NSString *headImagePath;
@property (strong, nonatomic) NSString *nick;
@property (strong, nonatomic) NSString *phoneNum;
@property (strong, nonatomic) NSString *address;
@end

@interface UserInfoDC : PPDataController

// Output
@property (nonatomic, strong) PersonModel *userInfoModel;
@end


