//
//  MainViewManager.h
//  Dentist
//
//  Created by Ben on 15/8/6.
//
//

#import <Foundation/Foundation.h>

@interface MainViewManager : NSObject

@property (nonatomic, strong) UITabBarController* tabBarController;

+ (MainViewManager*)sharedInstance;

#pragma mark - 页面切换

- (void)loadMainVC;

- (void)loadLoginVC;

#pragma mark - 工具方法

+ (UINavigationController *)rootNavigationController;

+ (UINavigationController *)currentTabNavigationController;

+ (UIViewController *)startupWindowTopVisibleContainerViewController;

+ (void)dismissAllPopupWindowAndView;

#pragma mark - tab control

- (MainTabIndexType)currentSelectedTabIndex;

- (void)popToRootTabViewControllerWithCompletion:(void (^)(void))completion;

- (void)selectTabHomeVC;

- (void)selectTabCategoryVC;

- (void)selectTabCartVC;

- (void)selectTabProfileVC;

#pragma mark - tab about

- (void)popAllTabNavToRoot;

- (void)clearAllTabRemindDot;

#pragma mark - UITabBar中的红点提示

- (BOOL)isShowTabBarRemindDotAtIndex:(MainTabIndexType)index;

- (void)showTabBarRemindDot:(BOOL)showDot atIndex:(MainTabIndexType)index;

@end