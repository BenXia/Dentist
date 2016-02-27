//
//  MainViewManager.m
//  Dentist
//
//  Created by Ben on 15/8/6.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "MainViewManager.h"
#import "AppDelegate.h"
#import "MainPageTabBarVC.h"
#import "HomePageVC.h"
#import "CategoryVC.h"
#import "CartVC.h"
#import "ProfileVC.h"
#import "LoginVC.h"
#import "GuidanceVC.h"

typedef enum {
    emLoginView,
    emMainView,
    emUnknown = 0xff
}MainViewType;

#define kTabBarDotViewTagOffset 2000
#define kBigRedDotHeight 10

@interface MainViewManager () <UITabBarControllerDelegate>

@property (nonatomic) MainViewType currentViewType;

@end


@implementation MainViewManager


static MainViewManager* sInstance = nil;

// 单例模式，整个进程仅此一个实例，来打印所有的log
+ (MainViewManager*)sharedInstance {
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        sInstance = [[self alloc] init];
        sInstance.currentViewType = emUnknown;
    });
    return sInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sInstance == nil) {
            sInstance = [super allocWithZone:zone];
            return sInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - Private Method

- (void)initMainView {
    _currentViewType = emMainView;
    _tabBarController = nil;
    
    HomePageVC *homePageVC = [[HomePageVC alloc] init];
    UINavigationController *nav1 = [[BaseNavigationController alloc] initWithRootViewController:homePageVC];
    
    CategoryVC *categoryVC = [[CategoryVC alloc] init];
    UINavigationController *nav2 = [[BaseNavigationController alloc] initWithRootViewController:categoryVC];
    
    CartVC *cartVC = [[CartVC alloc] init];
    UINavigationController *nav3 = [[BaseNavigationController alloc] initWithRootViewController:cartVC];

    ProfileVC *profileVC = [[ProfileVC alloc] init];
    UINavigationController *nav4 = [[BaseNavigationController alloc] initWithRootViewController:profileVC];
    
    _tabBarController = [[MainPageTabBarVC alloc] init];
    _tabBarController.tabBar.translucent = NO;
    _tabBarController.delegate = self;
    _tabBarController.viewControllers = [NSArray arrayWithObjects:
                                         nav1,
                                         nav2,
                                         nav3,
                                         nav4,
                                         nil];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       RGB(146,146,146), NSForegroundColorAttributeName,
                                                       [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                       nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor themeBlueColor], NSForegroundColorAttributeName,
                                                       [UIFont systemFontOfSize:14.0], NSFontAttributeName,
                                                       nil]
                                             forState:UIControlStateSelected];
    
    [[AppDelegate sharedAppDelegate] replaceRootControllerBy:_tabBarController];
}

- (void)popAllTabNavToRoot {
    for (id navVC in _tabBarController.viewControllers) {
        if([navVC isKindOfClass:[UINavigationController class]]){
            [((UINavigationController*)navVC) popToRootViewControllerAnimated:NO];
        }
    }
}

- (void)clearAllTabRemindDot {
    NSUInteger tabCount = _tabBarController.viewControllers.count;
    for (NSUInteger i=0; i < tabCount; ++i) {
        [self showTabBarRemindDot:NO atIndex:i];
    }
}

#pragma mark - 页面切换

- (void)loadMainVC {
    [self initMainView];

    [self selectTabHomeVC];
}

- (void)loadLoginVC {
    LoginVC *loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    [[AppDelegate sharedAppDelegate] replaceRootControllerBy:loginVC];
}

- (void)loadRegistVC {
    
}

- (void)loadGuidanceVCWithCompleteBlock:(Block)block{
    GuidanceVC* guidanceVC = [[GuidanceVC alloc] initWithCompleteBlock:block];
    [[AppDelegate sharedAppDelegate] replaceRootControllerBy:guidanceVC];
}

#pragma mark - Prepare view branching

- (id)tabSelectIndex:(NSInteger)index {
    if (index < _tabBarController.viewControllers.count) {
        [self.tabBarController setSelectedIndex:index];
        return [self.tabBarController selectedViewController];
    }
    return nil;
}

#pragma mark - UITabBarControllerDelegate 

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}

#pragma mark - 工具方法

+ (UINavigationController *)rootNavigationController {
    UINavigationController *navid = [AppDelegate sharedAppDelegate].rootNavigationController;
    return navid;
}

+ (UINavigationController *)currentTabNavigationController {
    UINavigationController *navid = [[MainViewManager sharedInstance].tabBarController.viewControllers objectAtIndex:[MainViewManager sharedInstance].tabBarController.selectedIndex];
    return navid;
}

+ (UIViewController *)startupWindowTopVisibleContainerViewController {
    UIViewController *vc = [AppDelegate sharedAppDelegate].window.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

+ (void)dismissAllPopupWindowAndView {
//    UIWindow *rootWindow = [AppDelegate sharedAppDelegate].window;
//    UIViewController *rootViewController = rootWindow.rootViewController;
//    
//    if (g_popupDatePickerVC) {
//        [g_popupDatePickerVC dismissWithAnimation:NO];
//    }
//    
//    if (g_popupShareActivityVC) {
//        [g_popupShareActivityVC dismissSharePopup];
//    }
//    
//    UIView *windowTopView = [rootWindow.subviews lastObject];
//    if (windowTopView.tag == kTagOfQQingPhotosBrowserVCView) {
//        QQingPhotosBrowserVC *photosBrowserVC = nil;
//        for (UIViewController *subVC in rootViewController.childViewControllers) {
//            if ([subVC isKindOfClass:[QQingPhotosBrowserVC class]]) {
//                photosBrowserVC = (QQingPhotosBrowserVC*)subVC;
//                break;
//            }
//        }
//        
//        if (photosBrowserVC) {
//            photosBrowserVC.delegate = nil;
//            [photosBrowserVC closeAction:nil];
//        }
//    }
}

#pragma mark - tab control

- (MainTabIndexType)currentSelectedTabIndex {
    if (_tabBarController == nil) {
        return kMainTabIndexType_Unknown;
    }
    
    return _tabBarController.selectedIndex;
}

- (void)popToRootTabViewControllerWithCompletion:(void (^)(void))completion {
    UIWindow *rootWindow = [AppDelegate sharedAppDelegate].window;
    UIViewController *rootViewController = rootWindow.rootViewController;
    UIViewController *startupWindowTopVisibleContainerViewController = [MainViewManager startupWindowTopVisibleContainerViewController];
    if (![rootViewController isKindOfClass:[UINavigationController class]]) {
        return;
    }
    
    UIViewController *rootTabViewController = [((UINavigationController *)rootViewController).viewControllers objectAtIndex:0];
    if (![rootTabViewController isKindOfClass:[UITabBarController class]]) {
        return;
    }
    
    [MainViewManager dismissAllPopupWindowAndView];
    
    if (startupWindowTopVisibleContainerViewController != rootViewController) {
        [rootViewController dismissViewControllerAnimated:NO completion:completion];
    } else {
        completion();
    }
}

- (void)selectTabHomeVC {
    if (self.tabBarController.selectedIndex != kMainTabIndexType_HomePage) {
        UINavigationController *oldRootNavigationVC = [self.tabBarController.viewControllers objectAtIndexIfIndexInBounds:self.tabBarController.selectedIndex];
        
        [self.tabBarController setSelectedIndex:kMainTabIndexType_HomePage];
        
        if (oldRootNavigationVC.visibleViewController != [oldRootNavigationVC.viewControllers objectAtIndexIfIndexInBounds:0]) {
            [oldRootNavigationVC popToRootViewControllerAnimated:NO];
        }
    }
    
    UINavigationController *rootNavigationVC = [self.tabBarController.viewControllers objectAtIndexIfIndexInBounds:kMainTabIndexType_HomePage];
    if (rootNavigationVC.visibleViewController != [rootNavigationVC.viewControllers objectAtIndexIfIndexInBounds:0]) {
        [rootNavigationVC popToRootViewControllerAnimated:NO];
    }
}

- (void)selectTabCategoryVC {
    if (self.tabBarController.selectedIndex != kMainTabIndexType_CategoryPage) {
        UINavigationController *oldRootNavigationVC = [self.tabBarController.viewControllers objectAtIndexIfIndexInBounds:self.tabBarController.selectedIndex];
        
        [self.tabBarController setSelectedIndex:kMainTabIndexType_CategoryPage];
        
        if (oldRootNavigationVC.visibleViewController != [oldRootNavigationVC.viewControllers objectAtIndexIfIndexInBounds:0]) {
            [oldRootNavigationVC popToRootViewControllerAnimated:NO];
        }
    }
    
    UINavigationController *rootNavigationVC = [self.tabBarController.viewControllers objectAtIndexIfIndexInBounds:kMainTabIndexType_CategoryPage];
    if (rootNavigationVC.visibleViewController != [rootNavigationVC.viewControllers objectAtIndexIfIndexInBounds:0]) {
        [rootNavigationVC popToRootViewControllerAnimated:NO];
    }
}

- (void)selectTabCartVC {
    if (self.tabBarController.selectedIndex != kMainTabIndexType_CartPage) {
        UINavigationController *oldRootNavigationVC = [self.tabBarController.viewControllers objectAtIndexIfIndexInBounds:self.tabBarController.selectedIndex];
        
        [self.tabBarController setSelectedIndex:kMainTabIndexType_CartPage];
        
        if (oldRootNavigationVC.visibleViewController != [oldRootNavigationVC.viewControllers objectAtIndexIfIndexInBounds:0]) {
            [oldRootNavigationVC popToRootViewControllerAnimated:NO];
        }
    }
    
    UINavigationController *rootNavigationVC = [self.tabBarController.viewControllers objectAtIndexIfIndexInBounds:kMainTabIndexType_CartPage];
    if (rootNavigationVC.visibleViewController != [rootNavigationVC.viewControllers objectAtIndexIfIndexInBounds:0]) {
        [rootNavigationVC popToRootViewControllerAnimated:NO];
    }
}

- (void)selectTabProfileVC {
    if (self.tabBarController.selectedIndex != kMainTabIndexType_ProfilePage) {
        UINavigationController *oldRootNavigationVC = [self.tabBarController.viewControllers objectAtIndexIfIndexInBounds:self.tabBarController.selectedIndex];
        
        [self.tabBarController setSelectedIndex:kMainTabIndexType_ProfilePage];
        
        if (oldRootNavigationVC.visibleViewController != [oldRootNavigationVC.viewControllers objectAtIndexIfIndexInBounds:0]) {
            [oldRootNavigationVC popToRootViewControllerAnimated:NO];
        }
    }
    
    UINavigationController *rootNavigationVC = [self.tabBarController.viewControllers objectAtIndexIfIndexInBounds:kMainTabIndexType_ProfilePage];
    if (rootNavigationVC.visibleViewController != [rootNavigationVC.viewControllers objectAtIndexIfIndexInBounds:0]) {
        [rootNavigationVC popToRootViewControllerAnimated:NO];
    }
}

#pragma mark - UITabBar中的红点提示

- (BOOL)isShowTabBarRemindDotAtIndex:(MainTabIndexType)index {
    UIImageView *dotImage = (UIImageView *)[self.tabBarController.tabBar viewWithTag:kTabBarDotViewTagOffset + index];
    
    if (dotImage && !dotImage.hidden) {
        return YES;
    } else {
        return NO;
    }
}

- (void)showTabBarRemindDot:(BOOL)showDot atIndex:(MainTabIndexType)index {
    if (index >= self.tabBarController.viewControllers.count) {
        return;
    }
    
    UIImageView *dotImage = (UIImageView *)[self.tabBarController.tabBar viewWithTag:kTabBarDotViewTagOffset + index];
    
    if (showDot) {
        if (!dotImage) { // 还未添加到bar上
            dotImage = [[UIImageView alloc] init];
            
            CGRect tabFrame = self.tabBarController.tabBar.frame;
            CGFloat x = ceilf((1.0 / self.tabBarController.viewControllers.count * (index + 1) - 0.1) * tabFrame.size.width);
            CGFloat y = ceilf(0.2 * tabFrame.size.height);
            
            dotImage.frame = CGRectMake(x, y, kBigRedDotHeight, kBigRedDotHeight);
            dotImage.layer.cornerRadius = kBigRedDotHeight / 2;
            dotImage.layer.masksToBounds = YES;
            dotImage.tag = kTabBarDotViewTagOffset + index;
            dotImage.backgroundColor = [UIColor redColor];
            [self.tabBarController.tabBar addSubview:dotImage];
        }
        
        dotImage.hidden = NO;
    } else {
        if (dotImage) {
            dotImage.hidden = YES;
        }
    }
}

@end
