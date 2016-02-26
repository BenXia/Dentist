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

@property (weak, nonatomic) IBOutlet UIView *topContentView;
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;

@property (weak, nonatomic) IBOutlet UIImageView *certificateImageView;
@property (weak, nonatomic) IBOutlet UILabel *certificateLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketInfoLabel;
@property (weak, nonatomic) IBOutlet UITextField *feedbackTextField;

@property (weak, nonatomic) IBOutlet UIImageView *payTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;

@end

@protocol OrderBottomInfoCellDelegate <NSObject>

@optional
- (void)didChangeFeedbackTextTo:(NSString *)feedbackText;
- (void)didClickCertificateButton;
- (void)didClickDeliverButton;
- (void)didClickTicketButton;
- (void)didClickPayTypeButton;

@end
