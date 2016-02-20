//
//  ProductDetailDC.h
//  Dentist
//
//  Created by 郭晓倩 on 16/2/20.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"
#import "ProductDetailModel.h"

@interface ProductDetailDC : PPDataController

@property (nonatomic,strong) NSString* productId;   //商品ID

@property (nonatomic,strong) ProductDetailModel* productDetail;

@end
