//
//  SendSmsDataController.h
//  Dentist
//
//  Created by Ben on 5/25/15.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface SendSmsDataController : PPDataController

// Input
@property (nonatomic, strong) NSString *phoneNumber;

// Output
@property (nonatomic, assign) int responseCode;

@end
