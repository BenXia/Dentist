//
//  OrderItemModel.h
//  Dentist
//
//  Created by Ben on 16/2/26.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductDetailModel.h"

@interface OrderItemModel : NSObject

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *productTitle;
@property (nonatomic, strong) NSString *productImageUrl;
@property (nonatomic, assign) double productPrice;
@property (nonatomic, assign) int buyNum;
@property (nonatomic, strong) NSString *descriptionString;

@end
