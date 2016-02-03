//
//  AppAppearance.h
//  Dentist
//
//  Created by Ben on 5/20/15.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  应用程序的外观 参数
 */
@interface AppAppearance : NSObject

@property (nonatomic, assign) CGFloat menuFontSize; // tabbar

@property (nonatomic, strong) UIColor *themeColor;


+ (instancetype)sharedAppearance;

@end
