//
//  BaseViewController.h
//  Dentist
//
//  Created by Ben on 10/15/15.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -

/**
 * Implemented by sub-classes of BaseViewController.
 */
@protocol ReactiveViewProtocol <NSObject>

@optional

- (void)bindViewModel;

- (void)bindViewModel:(id)vm;

@end

#pragma mark -

@interface BaseViewController : UIViewController <ReactiveViewProtocol>

@property (nonatomic, assign) NSInteger serviceState;

#pragma mark - Play with view model: overrided if needed

- (instancetype)initWithViewModel:(id)viewModel;

#pragma mark - Views operations: overrided if needed

- (void)initializeViews;

#pragma mark - Virtual method: Need to be overrided

/**
 *  Make constraints by code! Masonry is suggest.
 
 *  Call it at viewDidLoad 's end.
 */
- (void)applyViewConstraints;

/**
 *  Update Xib's constraints when needed.
 
 *  Call it where needed.
 */
- (void)updateVCviewsConstraints;

/**
 *  Just override api's method here.
 */
- (void)updateViewConstraints;

#pragma mark - NavigationBar style

// 修改当前导航栏背景色
- (UIColor *)preferNavBarBackgroundColor;

// 修改当前导航栏标题、左右按钮Normal状态标题颜色
- (UIColor *)preferNavBarNormalTitleColor;

// 修改左右按钮Highlighted标题颜色
- (UIColor *)preferNavBarHighlightedTitleColor;

#pragma mark - Navigation

- (void)pushVC:(UIViewController *)vc animate:(BOOL)animate;

- (void)pushVC:(UIViewController *)vc;

- (void)popVCAnimate:(BOOL)animate;

- (void)popVC;

- (void)popToVC:(UIViewController *)vc animate:(BOOL)animate;

- (void)popToVC:(UIViewController *)vc;

- (void)popToRootAnimate:(BOOL)animate;

- (void)popToRoot;

#pragma mark - Override methods

- (void)didClickOnBackButton;

#pragma mark - Utility

- (BOOL)isVisibleEx;

//显示系统自带的菊花
- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;

@end