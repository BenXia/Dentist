//
//  ProductAppraiseDC.h
//  Dentist
//
//  Created by 郭晓倩 on 16/2/26.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface ProductAppraiseDC : PPDataController

@property (strong,nonatomic) NSNumber* oid;     //订单号
@property (strong,nonatomic) NSArray* iid;      //点单号下产品ID,NSNumber数组
@property (strong,nonatomic) NSArray* score;    //针对某一个产品的打分
@property (strong,nonatomic) NSArray* content;  //产品评论
@property (strong,nonatomic) NSArray* imgs;     //产品图片

@property (assign,nonatomic) BOOL appraiseSuccess;
@property (strong,nonatomic) NSString* message;

@end
