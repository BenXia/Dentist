//
//  PayFailedVC.h
//  Dentist
//
//  Created by Ben on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayTypeVC.h"

@protocol PayFailedVCDelegate;

@interface PayFailedVC : BaseViewController

@property (nonatomic, assign) PayType currentPayType;
@property (nonatomic, weak) id<PayFailedVCDelegate> delegate;

@end

@protocol PayFailedVCDelegate <NSObject>

@optional
- (void)didChangePayType:(PayType)payType;
- (void)didClickPayAgainButtonInPayFailedVC;

@end
