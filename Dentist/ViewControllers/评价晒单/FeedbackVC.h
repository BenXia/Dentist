//
//  FeedbackVC.h
//  Dentist
//
//  Created by Ben on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNotificationAppraiseSuccess @"kNotificationAppraiseSuccess"

@interface FeedbackVC : UIViewController

//products为ProductListGoodsModel数组
-(instancetype)initWithOrderId:(NSString*)oid products:(NSArray*)products;

@end
