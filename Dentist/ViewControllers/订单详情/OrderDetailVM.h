//
//  OrderDetailVM.h
//  Dentist
//
//  Created by Ben on 2/21/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderDetailModel,OrderDetailDC,OrderConfermDC;
@interface OrderDetailVM : NSObject

@property(nonatomic, strong) OrderDetailDC  *orderDetailDC;
@property(nonatomic, strong) OrderConfermDC *orderConfermDC;

@end
