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
    return @{@"method":@"order.detail",@"v":@"0.0.1",@"auth":token,@"oid":[NSNumber numberWithInteger:self.oid.integerValue]};
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
        
        NSDictionary *orderDic = [resultDict objectForKey:@"order"];
        self.orderDetailModel = [OrderDetailModel new];
        self.orderDetailModel.orderStatus = [orderDic objectForKey:@"status"];
        //TODO-GUO:测试
//        self.orderDetailModel.orderStatus = @"3";

        self.orderDetailModel.orderShowNumber = [orderDic objectForKey:@"oid"];
        self.orderDetailModel.orderExpressCompany = [orderDic objectForKey:@"express_company"];
        self.orderDetailModel.pickUp = [orderDic objectForKey:@"pick_up"];
        self.orderDetailModel.orderPickUpCode = [orderDic objectForKey:@"pick_up_code"];
        self.orderDetailModel.orderExpressNumber = [orderDic objectForKey:@"expresssn"];
        self.orderDetailModel.orderReceiverName = [orderDic objectForKey:@"name"];
        self.orderDetailModel.orderReceiverPhone = [orderDic objectForKey:@"mobile"];
        self.orderDetailModel.orderReceiverAddress = [orderDic objectForKey:@"address"];
        
        NSString *paytime = [orderDic objectForKey:@"paytime"];
        NSDate* payDate = [NSDate dateWithTimeIntervalSince1970:[paytime longLongValue]];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.orderDetailModel.orderPayTime = [dateFormatter stringFromDate:payDate];
        
        NSString *createtime = [orderDic objectForKey:@"createtime"];
        NSDate* createDate = [NSDate dateWithTimeIntervalSince1970:[createtime longLongValue]];
        self.orderDetailModel.orderProduceTime = [dateFormatter stringFromDate:createDate];
        
        // TODO-Ben:
        self.orderDetailModel.isWexinPay = YES;
        self.orderDetailModel.piaoType = 0;
        self.orderDetailModel.piaoTitle = @"";
        self.orderDetailModel.piaoContent = @"";
        self.orderDetailModel.feedbackText = @"";
        
        ProductListModel *model = [ProductListModel new];
        model.orderID = [orderDic objectForKey:@"oid"];
        model.statusCode = [orderDic objectForKey:@"status"];
        model.productExpressPrice = [orderDic objectForKey:@"express_money"];

        NSMutableArray *goodsList = [orderDic objectForKey:@"goods"];
        for (NSDictionary *goodDic in goodsList) {
            ProductListGoodsModel *goodsModel = [ProductListGoodsModel new];
            goodsModel.productTitle = [goodDic objectForKey:@"title"];
            goodsModel.productModel = [goodDic objectForKey:@"sids"];
            goodsModel.productPrice = [goodDic objectForKey:@"price"];
            goodsModel.productNumber = [goodDic objectForKey:@"num"];
            goodsModel.productImageUrl = [goodDic objectForKey:@"img"];
            goodsModel.productID = [goodDic objectForKey:@"iid"];
            [model.productListGoodsArray addObject:goodsModel];
        }
        self.orderDetailModel.orderProductListModel = model;
        result = YES;
    }
    return result;
}

@end
