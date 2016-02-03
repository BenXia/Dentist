//
//  AppInitializer.h
//  Dentist
//
//  Created by Ben on 15/8/3.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInitializer : NSObject

+ (AppInitializer*)sharedInstance;

- (void)initiateAppAfterLaunching;

@end
