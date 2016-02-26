//
//  OrderListDC.m
//  Dentist
//
//  Created by Ben on 2/21/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "OrderListDC.h"
#import "ProductListModel.h"
#import "ProductListGoodsModel.h"


@implementation OrderListDC

- (NSDictionary *)requestURLArgs {
    NSString* token = [UserCache sharedUserCache].token ? [UserCache sharedUserCache].token : @"";
    if (self.next_iid.integerValue > 0) {
        return @{@"method":@"order.mylist",@"v":@"0.0.1",@"auth":token,@"next_iid":self.next_iid};
    } else {
        return @{@"method":@"order.mylist",@"v":@"0.0.1",@"auth":token};
    }
}

- (RequestMethod)requestMethod {
    return RequestMethodGET;
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    
    NSLog(@"响应数据：%@",content);
    
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        self.next_iid = [resultDict objectForKey:@"next_iid"];
        self.pagesize = [resultDict objectForKey:@"pagesize"];
        self.status = [resultDict objectForKey:@"status"];
        
        NSArray *ordersArray = [resultDict objectForKey:@"orders"];
        for (NSDictionary *ordersDic in ordersArray) {
            ProductListModel *model = [ProductListModel new];
            model.orderID = [ordersDic objectForKey:@"oid"];
            model.statusCode = [ordersDic objectForKey:@"status"];
            model.productExpressPrice = [ordersDic objectForKey:@"express_money"];
            
            NSMutableArray *goodsList = [ordersDic objectForKey:@"goods"];
            for (NSDictionary *goodDic in goodsList) {
                ProductListGoodsModel *goodsModel = [ProductListGoodsModel new];
                goodsModel.productTitle = [goodDic objectForKey:@"title"];
                goodsModel.productModel = [goodDic objectForKey:@"sids"];
                goodsModel.productPrice = [goodDic objectForKey:@"price"];
                goodsModel.productNumber = [goodDic objectForKey:@"num"];
                goodsModel.productImageUrl = [goodDic objectForKey:@"img"];
                [model.productListGoodsArray addObject:goodsModel];
            }
            [self.orderListArray addObject:model];
        }
        result = YES;
    }
    return result;
}

- (NSMutableArray *)orderListArray {
    if (_orderListArray == nil) {
        _orderListArray = [NSMutableArray new];
    }
    return _orderListArray;
}

@end
