//
//  SetNickDC.h
//  Dentist
//
//  Created by 王涛 on 16/2/21.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface SetNickDC : PPDataController
// Input
@property (nonatomic, strong) NSString *nick;
// Output
@property (nonatomic, assign) int responseCode;
@property (nonatomic, strong) NSString *responseMsg;
@end
