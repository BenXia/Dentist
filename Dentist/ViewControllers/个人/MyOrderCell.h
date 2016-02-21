//
//  MyOrderCell.h
//  Dentist
//
//  Created by 王涛 on 16/2/4.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OrderHandleType) {
    OrderHandle_WaitingPay,
    OrderHandle_WaitingPraise,
    OrderHandle_Done,
};

@protocol MyOrderCellDelegate <NSObject>

- (void)orderButtonClickedWithType:(OrderHandleType)orderHandleType;

@end

@interface MyOrderCell : UITableViewCell

@property (nonatomic, weak) id<MyOrderCellDelegate> delegate;

@end
