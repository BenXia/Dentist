//
//  PPConfirmOrderDC.h
//  Dentist
//
//  Created by Ben on 16/2/26.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPDataController.h"
#import "Address.h"
#import "OrderItemModel.h"

@interface PPConfirmOrderDC : PPDataController

@property (nonatomic, strong) NSString *groupIds;
@property (nonatomic, strong) NSMutableArray *productItemsArray;

//output
@property (nonatomic, assign) int responseCode;
@property (nonatomic, strong) NSString *responseMsg;
@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) NSArray *orderItemsArray;
@property (nonatomic, strong) NSArray *payTypeArray;
@property (nonatomic, assign) BOOL buyCert;
@property (nonatomic, assign) double goodsPrice;
@property (nonatomic, assign) double totoalPrice;
@property (nonatomic, assign) double kuaidiPrice;
@property (nonatomic, assign) BOOL enableKuaidi;
@property (nonatomic, assign) BOOL enableZiti;

@end
