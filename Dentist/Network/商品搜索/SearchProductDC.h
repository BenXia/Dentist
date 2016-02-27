//
//  ProductSearchDC.h
//  Dentist
//
//  Created by 郭晓倩 on 16/2/23.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"
#import "SearchProductModel.h"

@interface SearchProductDC : PPDataController

@property (strong,nonatomic) NSString* searchKey;//搜素内容
@property (strong,nonatomic) NSNumber* next_iid;
@property (strong,nonatomic) NSNumber* cid;         //主分类
@property (strong,nonatomic) NSNumber* s_cid;       //子分类

@property (strong,nonatomic) NSNumber* total_num;
@property (strong,nonatomic) NSMutableArray* products;  //searchProductModel数组

@end
