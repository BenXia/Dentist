//
//  AppInitializer.h
//  Dentist
//
//  Created by Ben on 15/8/3.
//
//

#import <Foundation/Foundation.h>

@interface AppInitializer : NSObject

+ (AppInitializer*)sharedInstance;

- (void)initiateAppAfterLaunching;

@end
