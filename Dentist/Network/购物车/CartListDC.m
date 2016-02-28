//
//  CardListDC.m
//  Dentist
//
//  Created by Ben on 2/23/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "CartListDC.h"
#import "ShoppingCartModel.h"

@implementation CartListDC

- (NSDictionary *)requestURLArgs {
    NSString* token = [UserCache sharedUserCache].token ? [UserCache sharedUserCache].token : @"";
    return @{@"method":@"order.cart",@"auth":token};
}

- (RequestMethod)requestMethod {
    return RequestMethodGET;
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    
    NSLog(@"购物车列表响应数据：%@",content);
    
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {

        NSArray *productsArray = [resultDict objectForKey:@"data"];
        for (NSDictionary *dic in productsArray) {
            ShoppingCartModel *model = [ShoppingCartModel new];
            model.shoppingCartProductID     = [dic objectForKey:@"iid"];
            model.shoppingCartProductNumber = [dic objectForKey:@"cart_num"];
            model.shoppingCartProductLastNumber = [dic objectForKey:@"cart_num"]; //保存购物车上一次数据
            model.shoppingCartProductSids = [dic objectForKey:@"sids"];
            model.shoppingCartProductPrice = [dic objectForKey:@"price"];
            model.shoppingCartProductSurplusNumber = [dic objectForKey:@"num"];
            model.shoppingCartProductIsDel = [dic objectForKey:@"is_del"];
            model.shoppingCartProductTitle = [dic objectForKey:@"title"];
            model.shoppingCartProductImage = [dic objectForKey:@"img"];
            model.shoppingCartProductBuyCert = [dic objectForKey:@"buy_cert"];
            [self.shoppingCartProductsArray addObject:model];
        }
        result = YES;
    }
    
    return result;
}

- (NSMutableArray *)shoppingCartProductsArray {
    if (_shoppingCartProductsArray == nil) {
        _shoppingCartProductsArray = [NSMutableArray new];
    }
    return _shoppingCartProductsArray;
}
@end
