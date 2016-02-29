//
//  ShoppingCardVM.h
//  Dentist
//
//  Created by Ben on 2/22/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartListDC.h"
#import "CartProductDeleteDC.h"
#import "AddFavoriteDC.h"
#import "CartProductUpdateNumberDC.h"

@interface ShoppingCardVM : NSObject

@property (nonatomic, strong) CartListDC *cartListDC;                               //
@property (nonatomic, strong) CartProductDeleteDC *cartProductDeleteDC;                               //
@property (nonatomic, strong) AddFavoriteDC *addFavoriteDC;                               //
@property (nonatomic, strong) CartProductUpdateNumberDC *cartProductUpdateNumberDC;                               //

@property (nonatomic, strong) NSMutableArray *shoppingCartProductCellEditArray;     //购物车商品列表编辑模式数组

@property (nonatomic, strong) NSMutableArray *shoppingCartProductCellSelectArray;     //购物车商品列表已选中的数组

@property (nonatomic, strong) NSMutableArray *shoppingCartProductCellDeleteArray;     //购物车商品删除数组

//总共商品个数
- (int)getShoppingCartProductsCount;
//已选中的商品个数
- (int)getShoppingCartProductsSelectCount;
//已选中的商品的价格
- (float)getShoppingCartProductsSelectTotalPrice;
//已选中的商品id数组
- (NSMutableArray *)getProductSelectIDArray;
//所有商品的id数组
- (NSMutableArray *)getAllProductIDArray;
//所有商品的数量数组
- (NSMutableArray *)getAllProductNumberArray;
//同步商品数量当前和之前数据一致
- (void)updateCurrentProductNumberToLastNumber;
//商品数量返回到之前数据
- (void)updateLastProductNumberToCurrentNumber;
//是否需要更新数量
- (BOOL)needUpdateProductNumber;


@end
