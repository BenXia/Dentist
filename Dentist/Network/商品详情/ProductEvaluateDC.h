//
//  ProductEvaluateDC.h
//  Dentist
//
//  Created by Ben on 2/24/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface ProductEvaluateDC : PPDataController

@property (nonatomic, strong) NSString *productId;     //商品id
@property (nonatomic, strong) NSNumber *nextId;        //下一页商品

@property (nonatomic, strong) NSMutableArray *productEvaluateArray;    //

@end
