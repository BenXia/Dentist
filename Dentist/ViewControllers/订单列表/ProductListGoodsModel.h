//
//  ProductListGoodsModel.h
//  Dentist
//
//  Created by Ben on 2/20/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductListGoodsModel : NSObject

@property (nonatomic, strong) NSString *productID;        //产品id
@property (nonatomic, strong) NSString *productTitle;     //产品标题
@property (nonatomic, strong) NSString *productModel;     //产品型号
@property (nonatomic, strong) NSString *productPrice;     //产品价格
@property (nonatomic, strong) NSString *productNumber;    //产品数量
@property (nonatomic, strong) NSString *productImageUrl;  //产品图片

@end
