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
    return @{@"method":@"item.get",@"iid":self.productId};
}

- (RequestMethod)requestMethod {
    return RequestMethodGET;
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        ProductDetailModel* model = [ProductDetailModel new];
        
        model.iid = [resultDict objectForKey:@"iid"];
        model.sids = [resultDict objectForKey:@"sids"];
        model.old_price = ((NSNumber*)[resultDict objectForKey:@"old_price"]).doubleValue;
        model.price = ((NSNumber*)[resultDict objectForKey:@"price"]).doubleValue;
        model.num = ((NSNumber*)[resultDict objectForKey:@"num"]).intValue;
        model.tid = [resultDict objectForKey:@"tid"];
        model.p_sids = [self parseSpecItemArray:[resultDict objectForKey:@"p_sids"]];
        model.cid = [resultDict objectForKey:@"cid"];
        model.s_cid = [resultDict objectForKey:@"s_cid"];
        model.bid = [resultDict objectForKey:@"bid"];
        model.title = [resultDict objectForKey:@"title"];
        model.code = [resultDict objectForKey:@"code"];
        model.buy_cert = ((NSNumber*)[resultDict objectForKey:@"buy_cert"]).intValue;
        model.description_p = [resultDict objectForKey:@"description"];
        model.gifts = [self parseGiftItemArray:[resultDict objectForKey:@"gifts"]];
        model.groups = [self parseGroupItemArray:[resultDict objectForKey:@"groups"]];
        model.update_time = ((NSNumber*)[resultDict objectForKey:@"update_time"]).longLongValue;
        model.p_iids = [self parseSpecProductItemArray:[resultDict objectForKey:@"p_iids"]];
        model.scores = [self parseScoreItemArray:[resultDict objectForKey:@"scores"]];
        
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

@end
