//
//  OrderVM.h
//  Dentist
//
//  Created by Ben on 16/2/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"

@interface OrderVM : NSObject

@property (nonatomic, strong) Address *addressModel;
@property (nonatomic, strong) NSMutableArray *productItemsArray;

@end
