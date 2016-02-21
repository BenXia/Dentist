//
//  SaleActivityCell.h
//  Dentist
//
//  Created by 王涛 on 16/2/4.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SaleActivityCell;
@protocol saleActivityCellDelegate <NSObject>

- (void)saleActivityCell:(SaleActivityCell *)cell toProductDetailWith:(NSString *)iid;

@end
@interface SaleActivityCell : UITableViewCell
@property (nonatomic, strong) NSArray *cellModelArray;
@property (nonatomic, weak) id<saleActivityCellDelegate>delegate;
@end
