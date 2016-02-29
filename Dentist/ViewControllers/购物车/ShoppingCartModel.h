//
//  ShoppingCartModel.h
//  Dentist
//
//  Created by Ben on 2/22/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartModel : NSObject

@property (nonatomic, strong) NSString *shoppingCartProductID;               //购物车商品id
@property (nonatomic, strong) NSString *shoppingCartProductNumber;           //购物车商品数量
@property (nonatomic, strong) NSString *shoppingCartProductSids;             //购物车商品属性
@property (nonatomic, strong) NSString *shoppingCartProductPrice;            //购物车商品价格
@property (nonatomic, strong) NSString *shoppingCartProductSurplusNumber;    //购物车商品剩余数量
@property (nonatomic, strong) NSString *shoppingCartProductIsDel;            //购物车商品是否被删除？
@property (nonatomic, strong) NSString *shoppingCartProductTitle;            //购物车商品标题
@property (nonatomic, strong) NSString *shoppingCartProductImage;            //购物车商品图片
@property (nonatomic, strong) NSString *shoppingCartProductBuyCert;          //购物车商品是否需要证书？
@property (nonatomic, strong) NSString *shoppingCartProductLastNumber;       //购物车商品上一次数量

@end
