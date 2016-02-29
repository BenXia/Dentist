//
//  HomePageCourseListCell.h
//  StudioCommon
//
//  Created by Ben on 2/2/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomePageCourseListCellDelegate;

extern NSString* const kHomePageCourseListCellIdentifier;

@interface HomePageCourseListCell : UITableViewCell

@property (nonatomic, weak) id<HomePageCourseListCellDelegate> delegate;

@end

@protocol HomePageCourseListCellDelegate <NSObject>

@optional

- (void)didCourseListCell:(HomePageCourseListCell *)cell scrollToOffset:(CGPoint)offset;
- (void)didCourseListCell:(HomePageCourseListCell *)cell clickMenuTitle:(NSString*)title;

@end
