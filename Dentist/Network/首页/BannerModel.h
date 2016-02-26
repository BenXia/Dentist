//
//  BannerModel.h
//  Dentist
//
//  Created by 王涛 on 16/1/23.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *iid;
@property (nonatomic, strong) NSString *imgUrl;

+ (BannerModel *)modelWithDict:(NSDictionary *)dict;
@end
