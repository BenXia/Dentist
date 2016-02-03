//
//  HomePageCourseListCell.h
//  StudioCommon
//
//  Created by Ben on 2/2/16.
//
//

#import <UIKit/UIKit.h>

@protocol HomePageCourseListCellDelegate;

extern NSString* const kHomePageCourseListCellIdentifier;

@interface HomePageCourseListCell : UITableViewCell

@property (nonatomic, weak) id<HomePageCourseListCellDelegate> delegate;

@end

@protocol HomePageCourseListCellDelegate <NSObject>

@optional
- (void)didSelectCourseWithId:(int)courseId;
- (void)didCourseListCell:(HomePageCourseListCell *)cell scrollToOffset:(CGPoint)offset;
- (void)didClickOnTestButtonAction:(id)sender;

@end
