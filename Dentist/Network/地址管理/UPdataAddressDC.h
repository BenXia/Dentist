//
//  UPdataAddressDC.h
//  Dentist
//
//  Created by 王涛 on 16/2/21.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface UPdataAddressDC : PPDataController
//input
@property (nonatomic, strong) NSString *recipientName;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *addressString;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic)         BOOL is_default; //非必填
@property (nonatomic, strong) NSString *aid; //修改地址时候传

//output
@property (nonatomic, assign) int responseCode;
@property (nonatomic, strong) NSString *responseMsg;

@end
