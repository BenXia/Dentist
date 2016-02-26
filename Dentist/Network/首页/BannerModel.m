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
    model.location = [dict objectForKey:@"location"];
    model.imgUrl = [dict objectForKey:@"img_url"];
    model.iid = [dict objectForKey:@"iid"];
    return model;
}
@end
