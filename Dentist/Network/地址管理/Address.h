//
//  Address.h
//  Dentist
//
//  Created by 王涛 on 16/2/21.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *recipientName;
@property (nonatomic, strong) NSString *detailAddress;
@property (nonatomic, strong) NSString *recipientPhoneNum;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *postCode;
@property (nonatomic) BOOL isDefault;
@end
