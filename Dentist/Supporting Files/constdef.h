//
//  constdef.h
//  Dentist
//
//  Created by Ben on 1/28/15.
//
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

#endif
