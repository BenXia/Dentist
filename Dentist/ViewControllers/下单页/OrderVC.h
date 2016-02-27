//
//  OrderVC.h
//  Dentist
//
//  Created by Ben on 16/2/15.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItemModel.h"

@interface OrderVC : BaseViewController

- (void)setProductItemsArray:(NSMutableArray *)productItemsArray;
- (void)setGroupId:(NSString *)groupIds;

@end
