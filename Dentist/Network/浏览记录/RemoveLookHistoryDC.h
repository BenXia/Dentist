//
//  RemoveLookHistoryDC.h
//  Dentist
//
//  Created by 郭晓倩 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface RemoveLookHistoryDC : PPDataController

@property (nonatomic,strong) NSArray* productIds;   //商品ID

//200	成功
@property (nonatomic,assign) int code;
@property (nonatomic,strong) NSString* message;


@end
