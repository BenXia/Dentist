//
//  CreateOrEditAddressVC.h
//  Dentist
//
//  Created by Ben on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kAddressToAdd,
    kAddressToChange,
} AddressTodoType;

@interface CreateOrEditAddressVC : BaseViewController
@property (nonatomic, assign) AddressTodoType type;
@property (nonatomic, strong) Address *addressModel;
@end
