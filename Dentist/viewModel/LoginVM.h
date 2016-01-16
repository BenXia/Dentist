//
//  LoginVM.h
//  Dentist
//
//  Created by 王涛 on 16/1/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginVM : NSObject

- (void)loginWithName:(NSString *)name PassWord:(NSString *)password;

- (void)autoLogin;

@end
