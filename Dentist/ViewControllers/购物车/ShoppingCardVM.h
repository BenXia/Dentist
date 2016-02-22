//
//  ShoppingCardVM.h
//  Dentist
//
//  Created by Ben on 2/22/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCardVM : NSObject

@property (nonatomic, strong) NSMutableArray *shoppingCartProductsArray;     //购物车商品列表

@property (nonatomic, strong) NSMutableArray *shoppingCartProductCellEditArray;     //购物车商品列表编辑模式数组

@property (nonatomic, strong) NSMutableArray *shoppingCartProductCellSelectArray;     //购物车商品列表已选中的数组

//总共商品个数
- (int)getShoppingCartProductsCount;
//已选中的商品个数
- (int)getShoppingCartProductsSelectCount;
//已选中的商品的价格
- (int)getShoppingCartProductsSelectTotalPrice;

@end
