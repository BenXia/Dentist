//
//  TodayIntroduceCell.h
//  Dentist
//
//  Created by 王涛 on 16/2/3.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TodayIntroduceCell;
@protocol TodayIntroduceCellDelegate <NSObject>

- (void)todayIntroduceCell:(TodayIntroduceCell *)cell toProductDetailWith:(NSString *)iid;

@end

@interface TodayIntroduceCell : UITableViewCell
@property (nonatomic, strong) id cellModel;
@property (nonatomic) id<TodayIntroduceCellDelegate>delegate;
@end
