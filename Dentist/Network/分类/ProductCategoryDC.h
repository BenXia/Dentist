//
//  ProductCategoryDC.h
//  Dentist
//
//  Created by 王涛 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface ProductCategoryDC : PPDataController
//input
@property (nonatomic, strong) NSString *md5;
//output
@property (nonatomic, assign) int responseCode;
@property (nonatomic, strong) NSString *responseMsg;
@property (nonatomic, strong) NSMutableArray *productCategoryArray;
@end
