//
//  GroupBuyingDC.h
//  Dentist
//
//  Created by 王涛 on 16/2/20.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface GroupBuyingDC : PPDataController
//output
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double start_time;
@property (nonatomic, assign) double end_time;
@property (nonatomic, strong) NSMutableArray *productArray;
@end
