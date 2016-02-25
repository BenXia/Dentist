//
//  ProductListModel.h
//  Dentist
//
//  Created by Ben on 2/20/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductListGoodsModel;
@interface ProductListModel : NSObject

@property (nonatomic, strong) NSString *orderID;               //订单id
@property (nonatomic, strong) NSString *statusCode;            //订单状态
@property (nonatomic, strong) NSString *productExpressPrice;   //快递费
@property (nonatomic, strong) NSMutableArray  *productListGoodsArray; //产品列表

@end
