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

- (float)getShoppingCartProductsSelectTotalPrice {
    float totalPrice = 0;
    for (ShoppingCartModel *model in self.shoppingCartProductCellSelectArray) {
        totalPrice += [model.shoppingCartProductNumber intValue]*[model.shoppingCartProductPrice floatValue];
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
    NSMutableArray *numberArray = [NSMutableArray new];
    for (ShoppingCartModel *model in self.cartListDC.shoppingCartProductsArray) {
        [numberArray addObject:model.shoppingCartProductNumber];
    }
    return numberArray;
}

- (void)updateCurrentProductNumberToLastNumber {
    for (NSString *idString in self.cartProductUpdateNumberDC.cartProductIdArray) {
        for (ShoppingCartModel *model in self.cartListDC.shoppingCartProductsArray) {
            if (idString.integerValue == model.shoppingCartProductID.integerValue) {
                model.shoppingCartProductLastNumber = model.shoppingCartProductNumber;
            }
        }
    }
}

- (void)updateLastProductNumberToCurrentNumber {
    for (NSString *idString in self.cartProductUpdateNumberDC.cartProductIdArray) {
        for (ShoppingCartModel *model in self.cartListDC.shoppingCartProductsArray) {
            if (idString.integerValue == model.shoppingCartProductID.integerValue) {
                model.shoppingCartProductNumber = model.shoppingCartProductLastNumber;
            }
        }
    }
}

- (BOOL)needUpdateProductNumber {
    for (NSString *idString in self.cartProductUpdateNumberDC.cartProductIdArray) {
        for (ShoppingCartModel *model in self.cartListDC.shoppingCartProductsArray) {
            if (idString.integerValue == model.shoppingCartProductID.integerValue) {
                if (model.shoppingCartProductNumber.intValue != model.shoppingCartProductLastNumber.intValue) {
                    return YES;
                }
            }
        }
    }
    return NO;
}
@end
