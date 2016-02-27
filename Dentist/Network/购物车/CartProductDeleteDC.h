//
//  CartProductDeleteDC.h
//  Dentist
//
//  Created by Ben on 2/24/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface CartProductDeleteDC : PPDataController

@property (nonatomic, strong) NSMutableArray *productIdArray;     //购物车商品id数组
@property (nonatomic, strong) NSNumber       *code;

@end
