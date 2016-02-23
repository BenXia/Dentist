//
//  MyFavoriteDC.h
//  Dentist
//
//  Created by 郭晓倩 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"
#import "FavoriteProductModel.h"

@interface MyFavoriteDC : PPDataController

@property (strong,nonatomic) NSNumber* total_num;
@property (strong,nonatomic) NSNumber* next_iid;
@property (strong,nonatomic) NSMutableArray* products;  //FavoriteProductModel数组

@end
