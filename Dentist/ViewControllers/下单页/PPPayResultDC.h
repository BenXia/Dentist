//
//  PPPayResultDC.h
//  Dentist
//
//  Created by Ben on 16/2/26.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface PPPayResultDC : PPDataController

@property (nonatomic, strong) NSString *oid;

// output
@property (nonatomic, assign) int responseCode;
@property (nonatomic, strong) NSString *responseMsg;

@property (nonatomic, strong) NSString *orderNumberString;
@property (nonatomic, strong) NSString *paytime;
@property (nonatomic, strong) NSString *createtime;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *province_name;
@property (nonatomic, strong) NSString *city_name;
@property (nonatomic, strong) NSString *area_name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSArray *pay;

@end
