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

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (nonatomic, weak) id<HomePageCourseListCellDelegate> delegate;

- (void)reloadData;

@end

@protocol HomePageCourseListCellDelegate <NSObject>

@optional
- (void)didSelectCourseWithId:(int)courseId;
- (void)didCourseListCell:(HomePageCourseListCell *)cell scrollToOffset:(CGPoint)offset;
- (void)didClickOnTestButtonAction:(id)sender;

@end
