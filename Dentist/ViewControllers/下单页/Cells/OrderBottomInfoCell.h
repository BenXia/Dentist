//
//  OrderBottomInfoCell.h
//  Dentist
//
//  Created by Ben on 16/2/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderBottomInfoCellDelegate;

@interface OrderBottomInfoCell : UITableViewCell

@property (nonatomic, weak) id<OrderBottomInfoCellDelegate> delegate;

@end

@protocol OrderBottomInfoCellDelegate <NSObject>

@optional
- (void)didClickCertificateButton;
- (void)didClickDeliverButton;
- (void)didClickTicketButton;
- (void)didClickPayTypeButton;

@end
