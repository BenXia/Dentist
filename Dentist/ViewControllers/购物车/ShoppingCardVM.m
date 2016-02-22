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
    }
    return self;
}

- (int)getShoppingCartProductsCount {
    int totalShoppingCardProductsNumber = 0;
    for (ShoppingCartModel *model in self.shoppingCartProductsArray) {
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

@end
