//
//  GetLookHistoryDC.h
//  Dentist
//
//  Created by 郭晓倩 on 16/2/23.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"
#import "FavoriteProductModel.h"

typedef FavoriteProductModel HistoryProductModel;

@interface GetLookHistoryDC : PPDataController

@property (strong,nonatomic) NSNumber* next_iid;

@property (strong,nonatomic) NSNumber* total_num;
@property (strong,nonatomic) NSMutableArray* products;  //HistoryProductModel数组


@end
