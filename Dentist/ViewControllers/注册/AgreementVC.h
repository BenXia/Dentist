//
//  AgreementVC.h
//  Dentist
//
//  Created by 王涛 on 16/1/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kAgreementA,
    kAgreementB,
} AgreemenrType;

@interface AgreementVC : UIViewController
@property (nonatomic, assign) AgreemenrType type;
@end
