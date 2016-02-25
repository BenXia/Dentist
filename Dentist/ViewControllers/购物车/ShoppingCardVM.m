//
//  ShoppingCardVM.m
//  Dentist
//
//  Created by Ben on 2/22/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "ShoppingCardVM.h"
#import "ShoppingCartModel.h"

@implementation ShoppingCardVM

- (id)init {
    if (self = [super init]) {
        self.shoppingCartProductCellEditArray = [NSMutableArray new];
        self.shoppingCartProductCellSelectArray = [NSMutableArray new];
        self.shoppingCartProductCellDeleteArray = [NSMutableArray new];
    }
    return self;
}

- (int)getShoppingCartProductsCount {
    int totalShoppingCardProductsNumber = 0;
    for (ShoppingCartModel *model in self.cartListDC.shoppingCartProductsArray) {
        totalShoppingCardProductsNumber += [model.shoppingCartProductNumber intValue];
    }
    return totalShoppingCardProductsNumber;
}

- (int)getShoppingCartProductsSelectCount {
    int totalShoppingCardProductsNumber = 0;
    for (ShoppingCartModel *model in self.shoppingCartProductCellSelectArray) {
        totalShoppingCardProductsNumber += [model.shoppingCartProductNumber intValue];
    }
    return totalShoppingCardProductsNumber;
}

- (int)getShoppingCartProductsSelectTotalPrice {
    int totalPrice = 0;
    for (ShoppingCartModel *model in self.shoppingCartProductCellSelectArray) {
        totalPrice += [model.shoppingCartProductNumber intValue]*[model.shoppingCartProductPrice intValue];
    }
    return totalPrice;
}

- (NSMutableArray *)getProductSelectIDArray {
    NSMutableArray *idArray = [NSMutableArray new];
    for (ShoppingCartModel *model in self.shoppingCartProductCellSelectArray) {
        [idArray addObject:model.shoppingCartProductID];
    }
    return idArray;
}

- (NSMutableArray *)getAllProductIDArray {
    NSMutableArray *idArray = [NSMutableArray new];
    for (ShoppingCartModel *model in self.cartListDC.shoppingCartProductsArray) {
        [idArray addObject:model.shoppingCartProductID];
    }
    return idArray;
}

- (NSMutableArray *)getAllProductNumberArray {
    NSMutableArray *idArray = [NSMutableArray new];
    for (ShoppingCartModel *model in self.cartListDC.shoppingCartProductsArray) {
        [idArray addObject:model.shoppingCartProductNumber];
    }
    return idArray;
}
@end
