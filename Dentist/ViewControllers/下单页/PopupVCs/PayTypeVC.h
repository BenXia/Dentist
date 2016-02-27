//
//  PayTypeVC.h
//  Dentist
//
//  Created by Ben on 16/2/25.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PayType) {
    PayType_WeChat = 0,
    PayType_AliPay = 1,
};

@protocol PayTypeVCDelegate;

@interface PayTypeVC : UIViewController

@property (nonatomic, weak) id<PayTypeVCDelegate> delegate;
@property (nonatomic, assign) PayType payType;

@end

@protocol PayTypeVCDelegate <NSObject>

@optional
- (void)didClickCancelButtonInPayTypeVC;
- (void)didClickConfirmButtonWithPayType:(PayType)payType;

@end
