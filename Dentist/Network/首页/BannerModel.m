//
//  BannerModel.m
//  Dentist
//
//  Created by 王涛 on 16/1/23.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "BannerModel.h"
@implementation BannerModel
+ (BannerModel *)modelWithDict:(NSDictionary *)dict {
    BannerModel *model = [[BannerModel alloc] init];
    model.name = [dict objectForKey:@"name"];
    model.imaUrl = [dict objectForKey:@"img_url"];
    model.cId = [[dict objectForKey:@"cid"] doubleValue];
    model.orderBy = [[dict objectForKey:@"orderby"] doubleValue];
    return model;
}
@end
