//
//  ChangeUserHeadImageDC.h
//  Dentist
//
//  Created by 王涛 on 16/2/18.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface ChangeUserHeadImageDC : PPDataController
// Input
@property (nonatomic, strong) UIImage *headImage;
// Output
@property (nonatomic, assign) int responseCode;
@property (nonatomic, strong) NSString *responseMsg;
@end
