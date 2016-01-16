//
//  LoginDC.h
//  Dentist
//
//  Created by 王涛 on 16/1/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface LoginDC : PPDataController
// Input
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *password;

// Output
@property (nonatomic, assign) BOOL loginSuccess;
@end
