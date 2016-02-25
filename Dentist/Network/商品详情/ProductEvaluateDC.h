//
//  ProductEvaluateDC.h
//  Dentist
//
//  Created by Ben on 2/24/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

static const int pageSize = 10;

@interface ProductEvaluateDC : PPDataController

@property (nonatomic, strong) NSString *cartProductId;     //购物车商品id

@end
