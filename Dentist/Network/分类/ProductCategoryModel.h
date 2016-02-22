//
//  ProductCategoryModel.h
//  Dentist
//
//  Created by 王涛 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCategoryModel : NSObject
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *orderby;
@property (nonatomic, strong) NSMutableArray *subCategoryArray;
@end
