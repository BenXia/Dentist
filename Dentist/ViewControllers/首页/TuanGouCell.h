//
//  TuanGouCell.h
//  Dentist
//
//  Created by 王涛 on 16/2/4.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TuanGouCell;
@protocol TuanGouCellDelegate <NSObject>

- (void)tuanGouCell:(TuanGouCell *)cell toProductDetailWith:(NSString *)iid;

@end

@interface TuanGouCell : UITableViewCell
@property (nonatomic, strong) NSArray *cellModelArray;
@property (nonatomic, weak) id<TuanGouCellDelegate>delegate;
@end
