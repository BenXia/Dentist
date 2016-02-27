//
//  OrderReceiverCell.h
//  Dentist
//
//  Created by Ben on 16/2/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderReceiverCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *receiverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverAddressLabel;

+ (CGFloat)heightWithAddress:(NSString *)receiverAddress;

@end
