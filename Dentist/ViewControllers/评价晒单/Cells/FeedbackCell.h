//
//  FeedbackCell.h
//  Dentist
//
//  Created by Ben on 16/2/23.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedbackModel.h"

@interface FeedbackCell : UITableViewCell

@property (nonatomic, strong) FeedbackModel *feedbackModel;

- (void)setupWithModel:(FeedbackModel *)feedbackModel;

+ (CGFloat)cellHeightWithModel:(FeedbackModel *)feedbackModel;

@end
