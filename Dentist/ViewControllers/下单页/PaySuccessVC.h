//
//  PaySuccessVC.h
//  Dentist
//
//  Created by Ben on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySuccessVC : BaseViewController

@property (nonatomic, strong) NSString *receiverName;
@property (nonatomic, strong) NSString *receiverPhoneNumber;
@property (nonatomic, strong) NSString *receiverAddress;

@property (nonatomic, strong) NSString *orderNumberString;
@property (nonatomic, strong) NSString *payDateString;
@property (nonatomic, strong) NSString *createOrderDateString;

@end
