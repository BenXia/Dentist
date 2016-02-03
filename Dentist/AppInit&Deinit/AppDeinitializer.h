//
//  AppDeinitializer.h
//  Dentist
//
//  Created by Ben on 15/8/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDeinitializer : NSObject

// it is singleton
+ (AppDeinitializer*)sharedInstance;

- (void)cleanUpWhenLogout;
- (void)cleanUpWhenSessionInvalid;
- (void)cleanUpWhenTokenInvalid;

@end
