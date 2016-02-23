//
//  FeedbackCell.m
//  Dentist
//
//  Created by Ben on 16/2/23.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "FeedbackCell.h"

@implementation FeedbackCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public methods

+ (CGFloat)cellHeight {
    return 270;
}

@end
