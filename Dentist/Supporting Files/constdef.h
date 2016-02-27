//
//  constdef.h
//  Dentist
//
//  Created by Ben on 1/28/15.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#ifndef Dentist_constdef_h
#define Dentist_constdef_h

/**
 *  用于NSUserDefault的存储键值
 */
#define kNotFirstLaunchApp  @"NotFirstLaunchApp"

typedef NS_ENUM(NSUInteger, MainTabIndexType) {
    kMainTabIndexType_HomePage           = 0,
    kMainTabIndexType_CategoryPage       = 1,
    kMainTabIndexType_CartPage           = 2,
    kMainTabIndexType_ProfilePage        = 3,
    kMainTabIndexType_Unknown            = 100,
};

// 颜色相关
#define kWhiteHighlightedColor          RGBA(150, 150, 150, 1.0f)
#define kBlackHighlightedColor          [UIColor lightGrayColor]
#define kBlankOldY 120

// 支付相关
#define kWeiXinAppID @"wx983825eaeef912b7"
#define kWeiXinMCHID @"1292687201"
#define kWeiXinKEY   @"gkuguRSRGF54kipo987t5vc421098klJ"
#define kWeiXinAPPSECRET @"d4624c36b6795d1d99dcf0547af5443d"


#endif
