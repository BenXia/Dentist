//
//  DeliverTypeVC.h
//  Dentist
//
//  Created by Ben on 16/2/25.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DeliverType) {
    DeliverType_KuaiDi = 0,
    DeliverType_ZiTi = 1
};

@protocol DeliverTypeVCDelegate;

@interface DeliverTypeVC : UIViewController

@property (nonatomic, strong) NSArray *priceArray;
@property (nonatomic, assign) DeliverType deliverType;
@property (nonatomic, weak) id<DeliverTypeVCDelegate> delegate;

@end

@protocol DeliverTypeVCDelegate <NSObject>

@optional
- (void)didClickCancelButtonInDeliverTypeVC;
- (void)didClickConfirmButtonWithDeliverType:(DeliverType)deliverType price:(CGFloat)price;

@end
