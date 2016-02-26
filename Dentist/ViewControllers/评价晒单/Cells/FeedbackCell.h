//
//  FeedbackCell.h
//  Dentist
//
//  Created by Ben on 16/2/23.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedbackModel.h"

@protocol FeedbackCellDelegate;

@interface FeedbackCell : UITableViewCell

@property (nonatomic, weak) id<FeedbackCellDelegate> delegate;

@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, strong) FeedbackModel *feedbackModel;

- (void)setupWithModel:(FeedbackModel*)feedbackModel;

+ (CGFloat)cellHeightWithModel:(FeedbackModel *)productModel;

@end

@protocol FeedbackCellDelegate <NSObject>

@optional
- (void)setStatusBarHidden:(BOOL)statusBarHidden;
- (void)needReloadData;

@end
