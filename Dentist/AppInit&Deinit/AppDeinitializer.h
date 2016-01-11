//
//  AppDeinitializer.h
//  Dentist
//
//  Created by Ben on 15/8/22.
//
//

#import <Foundation/Foundation.h>

@interface AppDeinitializer : NSObject

// it is singleton
+ (AppDeinitializer*)sharedInstance;

- (void)cleanUpWhenLogout;
- (void)cleanUpWhenSessionInvalid;
- (void)cleanUpWhenTokenInvalid;

@end
