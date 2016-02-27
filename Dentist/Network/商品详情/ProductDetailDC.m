//
//  ProductDetailDC.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/20.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "ProductDetailDC.h"

@implementation ProductDetailDC

- (NSDictionary *)requestURLArgs {
    NSString* token = [UserCache sharedUserCache].token ? [UserCache sharedUserCache].token : @"";
    return @{@"method":@"item.get",@"iid":self.productId,@"auth":token};
}

- (RequestMethod)requestMethod {
    return RequestMethodGET;
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    
    NSLog(@"商品详情响应数据：%@",content);
    
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        ProductDetailModel* model = [ProductDetailModel new];
        
        model.iid = [resultDict objectForKey:@"iid"];
        model.sids = [resultDict objectForKey:@"sids"];
        model.old_price = ((NSString*)[resultDict objectForKey:@"old_price"]).doubleValue;
        model.price = ((NSString*)[resultDict objectForKey:@"price"]).doubleValue;
        model.num = ((NSString*)[resultDict objectForKey:@"num"]).intValue;
        model.tid = [resultDict objectForKey:@"tid"];
        model.p_sids = [self parseSpecItemArray:[resultDict objectForKey:@"p_sids"]];
        model.cid = [resultDict objectForKey:@"cid"];
        model.s_cid = [resultDict objectForKey:@"s_cid"];
        model.bid = [resultDict objectForKey:@"bid"];
        model.title = [resultDict objectForKey:@"title"];
        model.title_fu = [resultDict objectForKey:@"title_fu"];
        model.img_url = [resultDict objectForKey:@"img_url"];
        model.code = [resultDict objectForKey:@"code"];
        model.buy_cert = ((NSString*)[resultDict objectForKey:@"buy_cert"]).intValue;
        model.description_p = [resultDict objectForKey:@"description"];
        model.gifts = [self parseGiftItemArray:[resultDict objectForKey:@"gifts"]];
        model.groups = [self parseGroupItemArray:[resultDict objectForKey:@"groups"]];
        model.update_time = ((NSString*)[resultDict objectForKey:@"update_time"]).longLongValue;
        model.p_iids = [self parseSpecProductItemArray:[resultDict objectForKey:@"p_iids"]];
        model.scores = [self parseScoreItemArray:[resultDict objectForKey:@"scores"]];
        
        model.express = ((NSString*)[resultDict objectForKey:@"express"]).intValue;
        model.pick_up = ((NSString*)[resultDict objectForKey:@"pick_up"]).intValue;
        model.is_del = ((NSString*)[resultDict objectForKey:@"pick_up"]).intValue;
        model.item_is_del = ((NSString*)[resultDict objectForKey:@"item_is_del"]).intValue;
        
        model.likes = [self parseLikeItemArray:[resultDict objectForKey:@"likes"]];
        model.product_score = ((NSString*)[resultDict objectForKey:@"product_score"]).intValue;
        model.product_score_good = ((NSNumber*)[resultDict objectForKey:@"product_score_good"]).intValue;
        
        model.is_baoyou = ((NSNumber*)[resultDict objectForKey:@"is_baoyou"]).boolValue;
        
        
        NSNumber* code = [resultDict objectForKey:@"code"];
        NSString* message = [resultDict objectForKey:@"msg"];
        if (code && code.intValue != 200) {
            NSLog(@"商品详情响应码:%d 消息:%@",code.intValue,message);
        }
        
//        //TODO-GUO:测试数据
//        if(model.p_sids.count == 0){
//            NSMutableArray* itemArray = [NSMutableArray new];
//            SpecItem* item = [SpecItem new];
//            item.name = @"颜色";
//            item.data = @[@"红色",@"紫罗兰色",@"红色",@"紫罗兰色",@"红色",@"紫罗兰色",@"红色",@"紫罗兰色",@"红色",@"紫罗兰色",@"红色",@"紫罗兰色",@"红色",@"紫罗兰色"];
//            [itemArray addObject:item];
//            
//            SpecItem* item2 = [SpecItem new];
//            item2.name = @"尺寸";
//            item2.data = @[@"大号",@"XXXXXXXL号",@"大号",@"XXXXXXXL号",@"大号",@"XXXXXXXL号",@"大号",@"XXXXXXXL号",@"大号",@"XXXXXXXL号"];
//            [itemArray addObject:item2];
//            model.p_sids = itemArray;
//            model.sids = @"颜色:红色,尺寸:XXXXXXXL号";
//        }
//        
//        if(model.scores.count == 0){
//            NSMutableArray* scores = [NSMutableArray new];
//            for (int i=1; i<=5; ++i) {
//                ScoreItem* item = [ScoreItem new];
//                item.score = i;
//                item.addtime = [[NSDate date] timeIntervalSince1970];
//                item.nickname = @"哈哈哈";
//                item.imgs = @[@"sss",@"sss"];
//                item.content = @"快拉萨的费拉拉富士康精品阿斯兰的首付款可拉伸疯掉了看见都烦死了看见的说服力卡戴珊弗兰克的说服力的分水岭快递费失联客机";
//                [scores addObject:item];
//            }
//            model.scores = scores;
//        }
//        
//        if(model.gifts.count == 0){
//            NSMutableArray* gifts = [NSMutableArray new];
//            for (int i=1; i<=5; ++i) {
//                GiftItem* item = [GiftItem new];
//                item.title = [NSString stringWithFormat:@"我是赠品%d",i];
//                [gifts addObject:item];
//            }
//            model.gifts = gifts;
//        }
        
        
        
        self.productDetail = model;
        result = YES;
    }
    
    return result;
}

-(NSArray*)parseSpecItemArray:(NSArray*)dicArray{
    NSMutableArray* itemArray = [NSMutableArray new];
    for (NSDictionary* dic in dicArray) {
        SpecItem* item = [SpecItem new];
        item.name = [dic objectForKey:@"name"];
        item.data = [dic objectForKey:@"data"];
        [itemArray addObject:item];
    }
    return itemArray;
}

-(NSArray*)parseSpecProductItemArray:(NSArray*)dicArray{
    NSMutableArray* itemArray = [NSMutableArray new];
    for (NSDictionary* dic in dicArray) {
        SpecProductItem* item = [SpecProductItem new];
        item.iid = [dic objectForKey:@"iid"];
        item.sids = [dic objectForKey:@"sids"];
        item.num = ((NSNumber*)[dic objectForKey:@"num"]).intValue;
        [itemArray addObject:item];
    }
    return itemArray;
}

-(NSArray*)parseGiftItemArray:(NSArray*)dicArray{
    NSMutableArray* itemArray = [NSMutableArray new];
    for (NSDictionary* dic in dicArray) {
        GiftItem* item = [GiftItem new];
        item.title = [dic objectForKey:@"title"];
        item.img_url = [dic objectForKey:@"img_url"];
        item.g_code = [dic objectForKey:@"g_code"];
        item.num = ((NSNumber*)[dic objectForKey:@"num"]).intValue;
        [itemArray addObject:item];
    }
    return itemArray;
}

-(NSArray*)parseGroupItemArray:(NSArray*)dicArray{
    NSMutableArray* itemArray = [NSMutableArray new];
    for (NSDictionary* dic in dicArray) {
        GroupItem* item = [GroupItem new];
        item.name = [dic objectForKey:@"name"];
        item.pgp_id = [dic objectForKey:@"pgp_id"];
        item.price = ((NSNumber*)[dic objectForKey:@"price"]).doubleValue;
        item.items = [self parseGroupContentItemArray:[dic objectForKey:@"items"]];
        [itemArray addObject:item];
    }
    return itemArray;
}

-(NSArray*)parseGroupContentItemArray:(NSArray*)dicArray{
    NSMutableArray* itemArray = [NSMutableArray new];
    for (NSDictionary* dic in dicArray) {
        GroupContentItem* item = [GroupContentItem new];
        item.iid = [dic objectForKey:@"iid"];
        item.img = [dic objectForKey:@"img"];
        item.title = [dic objectForKey:@"title"];
        item.price = ((NSNumber*)[dic objectForKey:@"price"]).doubleValue;
        [itemArray addObject:item];
    }
    return itemArray;
}

-(NSArray*)parseScoreItemArray:(NSArray*)dicArray{
    NSMutableArray* itemArray = [NSMutableArray new];
    for (NSDictionary* dic in dicArray) {
        ScoreItem* item = [ScoreItem new];
        item.imgs = [dic objectForKey:@"imgs"];
        item.content = [dic objectForKey:@"content"];
        item.score = ((NSNumber*)[dic objectForKey:@"score"]).intValue;
        item.addtime = ((NSNumber*)[dic objectForKey:@"addtime"]).longLongValue;
        item.nickname = [dic objectForKey:@"nickname"];
        [itemArray addObject:item];
    }
    return itemArray;
}

-(NSArray*)parseLikeItemArray:(NSArray*)dicArray{
    NSMutableArray* itemArray = [NSMutableArray new];
    for (NSDictionary* dic in dicArray) {
        LikeProductItem* item = [LikeProductItem new];
        item.iid = [dic objectForKey:@"iid"];
        item.img = [dic objectForKey:@"img_url"];
        item.title = [dic objectForKey:@"title"];
        item.price = ((NSNumber*)[dic objectForKey:@"price"]).doubleValue;
        [itemArray addObject:item];
    }
    return itemArray;
}

@end
