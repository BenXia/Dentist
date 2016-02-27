//
//  SearchProductModel.h
//  Dentist
//
//  Created by 郭晓倩 on 16/2/27.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchProductModel : NSObject

@property (strong,nonatomic) NSString* iid;
@property (strong,nonatomic) NSString* title;
@property (strong,nonatomic) NSString* img_url;
@property (strong,nonatomic) NSString* price;

@property (assign,nonatomic) BOOL hasGift;
@property (assign,nonatomic) BOOL hasFreeSend;

@end
