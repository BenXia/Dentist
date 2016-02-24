//
//  DeleteAddressDC.h
//  Dentist
//
//  Created by 王涛 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface DeleteAddressDC : PPDataController
@property (nonatomic, strong) NSString *aid; //修改地址时候传

//output
@property (nonatomic, assign) int responseCode;
@property (nonatomic, strong) NSString *responseMsg;
@end
