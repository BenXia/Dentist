//
//  AddCartDC.h
//  Dentist
//
//  Created by 郭晓倩 on 16/2/21.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface AddCartDC : PPDataController

@property (nonatomic,strong) NSArray* productIds;   //商品ID
@property (nonatomic,strong) NSArray* cartNums;

//101	需要登录
//403	有IID不存在或已下架！
//200	成功
@property (nonatomic,assign) int code;
@property (nonatomic,strong) NSString* message;

@end
