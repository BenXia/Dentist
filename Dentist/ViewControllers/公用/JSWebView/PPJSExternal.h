//
//  PPJSExternal.h
//  Dentist
//
//  Created by Ben on 15/8/1.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPDataController.h"

@protocol PPJSExternalDelegate <NSObject>

@optional
- (void)PPJSExternalFinish:(NSDictionary *)dic;
- (void)PPJSShowAlert :(NSDictionary *)dic;

@end

@interface PPJSExternal : NSObject

@property (nonatomic , weak) id<PPJSExternalDelegate> delegate;

@end

