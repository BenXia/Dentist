//
//  OrderDetailDC.h
//  Dentist
//
//  Created by Ben on 2/23/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "PPDataController.h"
#import "OrderDetailModel.h"

@interface OrderDetailDC : PPDataController

@property(nonatomic, strong) NSString *oid;
@property(nonatomic, strong) OrderDetailModel *orderDetailModel;

@end
