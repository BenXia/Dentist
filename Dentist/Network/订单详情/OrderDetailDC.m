//
//  OrderDetailDC.m
//  Dentist
//
//  Created by Ben on 2/23/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "OrderDetailDC.h"
#import "ProductListModel.h"
#import "ProductListGoodsModel.h"

@implementation OrderDetailDC


- (NSDictionary *)requestURLArgs {
    NSString* token = [UserCache sharedUserCache].token ? [UserCache sharedUserCache].token : @"";
    return @{@"method":@"order.detail",@"v":@"0.0.1",@"auth":token,@"oid":self.oid};
}

- (RequestMethod)requestMethod {
    return RequestMethodGET;
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    
    NSLog(@"订单详情响应数据：%@",content);
    
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        self.orderDetailModel.orderStatus = [resultDict objectForKey:@"status"];
        self.orderDetailModel.orderShowNumber = [resultDict objectForKey:@"oid"];
        self.orderDetailModel.orderExpressCompany = [resultDict objectForKey:@"express_company"];
        self.orderDetailModel.orderPickUpCode = [resultDict objectForKey:@"pick_up_code"];
        self.orderDetailModel.orderExpressNumber = [resultDict objectForKey:@"expresssn"];
        self.orderDetailModel.orderReceiverName = [resultDict objectForKey:@"name"];
        self.orderDetailModel.orderReceiverPhone = [resultDict objectForKey:@"mobile"];
        self.orderDetailModel.orderReceiverAddress = [resultDict objectForKey:@"address"];
        self.orderDetailModel.orderPayTime = [resultDict objectForKey:@"paytime"];
        self.orderDetailModel.orderProduceTime = [resultDict objectForKey:@"createtime"];
        
        ProductListModel *model = [ProductListModel new];
        model.orderShowNumber = [resultDict objectForKey:@"oid"];
        model.statusCode = [resultDict objectForKey:@"status"];
        model.productExpressPrice = [resultDict objectForKey:@"express_money"];

        NSMutableArray *goodsList = [resultDict objectForKey:@"goods"];
        for (NSDictionary *goodDic in goodsList) {
            ProductListGoodsModel *goodsModel = [ProductListGoodsModel new];
            goodsModel.productTitle = [goodDic objectForKey:@"title"];
            goodsModel.productModel = [goodDic objectForKey:@"sids"];
            goodsModel.productPrice = [goodDic objectForKey:@"price"];
            goodsModel.productNumber = [goodDic objectForKey:@"num"];
            goodsModel.productImageUrl = [goodDic objectForKey:@"img"];
            [model.productListGoodsArray addObject:goodsModel];
        }

        self.orderDetailModel.orderProductListModel = model;
        result = YES;
    }
    return result;
}

@end
