//
//  ProductIntroduceModel.h
//  Dentist
//
//  Created by 王涛 on 16/2/20.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductIntroduceModel : NSObject

@property (nonatomic, strong) NSString *location;    //位置有banner,左1,右1,右2
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *img_url;
@property (nonatomic, strong) NSString *iid;
@property (nonatomic, strong) NSString *event_id;

@end
