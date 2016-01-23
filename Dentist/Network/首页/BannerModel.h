//
//  BannerModel.h
//  Dentist
//
//  Created by 王涛 on 16/1/23.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imaUrl;
@property (nonatomic, assign) double cId;
@property (nonatomic, assign) double orderBy;

+ (BannerModel *)modelWithDict:(NSDictionary *)dict;
@end
