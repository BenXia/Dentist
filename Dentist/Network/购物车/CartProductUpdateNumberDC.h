//
//  CartProductUpdateNumberDC.h
//  Dentist
//
//  Created by Ben on 2/24/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface CartProductUpdateNumberDC : PPDataController

@property (nonatomic, strong) NSMutableArray *cartProductIdArray;     //购物车商品id
@property (nonatomic, assign) NSMutableArray *productNumberArray;     //购物车商品数量

@property (nonatomic, strong) NSNumber       *code;

@end
