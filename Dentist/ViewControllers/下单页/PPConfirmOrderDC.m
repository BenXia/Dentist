//
//  PPConfirmOrderDC.m
//  Dentist
//
//  Created by Ben on 16/2/26.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPConfirmOrderDC.h"

@implementation PPConfirmOrderDC

- (NSDictionary *)requestURLArgs {
    return @{@"method":@"order.confirm",@"v":@"0.0.1",@"auth":[UserCache sharedUserCache].token};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

- (void)requestWillStart {
    [super requestWillStart];
    
    self.responseMsg = @"";
}

- (NSDictionary *)requestHTTPBody {
    if (self.groupIds) {
        NSString *mainProductIds = ((OrderItemModel *)[self.productItemsArray objectAtIndex:0]).productId;
        
        return @{@"iid":mainProductIds, @"pgp_id": self.groupIds};
    } else {
        NSMutableArray *idsArray = [NSMutableArray array];
        NSMutableArray *numsArray = [NSMutableArray array];
        
        for (OrderItemModel *model in self.productItemsArray) {
            [idsArray addObject:model.productId];
            [numsArray addObject:[NSString stringWithFormat:@"%d", model.buyNum]];
        }
        
        return @{@"iid[]":idsArray, @"cart_num[]":numsArray};
    }
}

- (BOOL)parseContent:(NSString *)content {
    NSLog(@"确认订单响应数据：%@",content);
    
    BOOL result = NO;
    NSError *error = nil;
    NSDictionary *resultdict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultdict isKindOfClass:[NSDictionary class]]) {
        self.responseCode = [[resultdict objectForKey:@"code"] intValue];
        self.responseMsg = [resultdict objectForKey:@"msg"];
        
        if (self.responseCode != 200) {
            return NO;
        }
        
        NSDictionary *addressDict = [resultdict objectForKey:@"address"];
        if ([addressDict isKindOfClass:[NSArray class]]) {
            addressDict = [((NSArray *)addressDict) firstObject];
        }
        Address *addressModel = [[Address alloc] init];
        addressModel.province = [addressDict objectForKey:@"province_name"];
        addressModel.city = [addressDict objectForKey:@"city_name"];
        addressModel.area = [addressDict objectForKey:@"area_name"];
        addressModel.detailAddress = [addressDict objectForKey:@"address"];
        addressModel.recipientName = [addressDict objectForKey:@"name"];
        addressModel.recipientPhoneNum = [addressDict objectForKey:@"mobile"];
        addressModel.postCode = [addressDict objectForKey:@"zipcode"];
        addressModel.ID = [addressDict objectForKey:@"aid"];
        addressModel.isDefault = [[addressDict objectForKey:@"is_default"] isEqualToString:@"1"];
        self.address = addressModel;
        
        NSMutableArray *orderItemsArray = [NSMutableArray array];
        NSDictionary *itemsDict = [resultdict objectForKey:@"items"];
        for (NSDictionary *dic in itemsDict) {
            OrderItemModel *orderItem = [OrderItemModel new];
            
            orderItem.productId = [dic objectForKey:@"iid"];
            orderItem.productTitle = [dic objectForKey:@"title"];
            orderItem.productImageUrl = [dic objectForKey:@"img"];
            orderItem.productPrice = [[dic objectForKey:@"price"] floatValue];
            orderItem.buyNum = [[dic objectForKey:@"cart_num"] intValue];
            orderItem.descriptionString = [dic objectForKey:@"sids"];
            
            [orderItemsArray addObject:orderItem];
            
//            model.shoppingCartProductID     = [dic objectForKey:@"iid"];
//            model.shoppingCartProductNumber = [dic objectForKey:@"cart_num"];
//            model.shoppingCartProductSids = [dic objectForKey:@"sids"];
//            model.shoppingCartProductPrice = [dic objectForKey:@"price"];
//            model.shoppingCartProductSurplusNumber = [dic objectForKey:@"num"];
//            model.shoppingCartProductIsDel = [dic objectForKey:@"is_del"];
//            model.shoppingCartProductTitle = [dic objectForKey:@"title"];
//            model.shoppingCartProductImage = [dic objectForKey:@"img"];
//            model.shoppingCartProductBuyCert = [dic objectForKey:@"buy_cert"];
        }
        self.orderItemsArray = [NSArray arrayWithArray:orderItemsArray];
        
        self.payTypeArray = [resultdict objectForKey:@"pay"];
        self.buyCert = [[resultdict objectForKey:@"buy_cert"] boolValue];
        self.goodsPrice = [[resultdict objectForKey:@"goods_money"] doubleValue];
        self.totoalPrice = [[resultdict objectForKey:@"total_money"] doubleValue];
        self.kuaidiPrice = [[resultdict objectForKey:@"express_money"] doubleValue];
        self.enableKuaidi = [[resultdict objectForKey:@"express"] boolValue];
        self.enableZiti = [[resultdict objectForKey:@"pick_up"] boolValue];
        
        result = YES;
    }
    
    return result;
}

@end
