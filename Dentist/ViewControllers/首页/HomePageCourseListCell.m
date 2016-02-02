//
//  HomePageCourseListCell.m
//  StudioCommon
//
//  Created by Ben on 2/2/16.
//
//

#import "HomePageCourseListCell.h"

static const CGFloat kCourseItemHeight = 60;

static NSArray* kHomePageCourseListSortArray;

NSString* const kHomePageCourseListCellIdentifier = @"HomePageCourseListCell";

@interface HomePageCourseListCell () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewWidthConstaint;

@end

@implementation HomePageCourseListCell

+ (void)initialize {
    [super initialize];
    
    kHomePageCourseListSortArray = @[@"临床", @"技工", @"定制套装", @"培训课程"];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.scrollContentView removeAllSubviews];
}

- (void)reloadData {
    [self.scrollContentView removeAllSubviews];
    NSArray *courseArray = @[@"临床", @"技工", @"定制套装", @"培训课程"];
    self.scrollContentViewWidthConstaint.constant = kScreenWidth;
    
    for (int i = 0; i < courseArray.count; i++) {
        NSString *courseModel = [courseArray objectAtIndexIfIndexInBounds:i];
        float step = kScreenWidth/courseArray.count*1.0;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * step, 10, step, kCourseItemHeight)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:courseModel] forState:UIControlStateNormal];
        [button setTitle:courseModel forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18.f];
        button.tag = 1000+i;
        [button addTarget:self action:@selector(didClickOnCourseButton:) forControlEvents:UIControlEventTouchUpInside];
        //[button centerImageAndTitle];
        
        [self.scrollContentView addSubview:button];
    }

}

#pragma mark - IBActions

- (void)didClickOnCourseButton:(UIButton *)courseButton {
    if ([self.delegate respondsToSelector:@selector(didSelectCourseWithId:)]) {
        [self.delegate didSelectCourseWithId:(int)courseButton.tag];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    if ([self.delegate respondsToSelector:@selector(didCourseListCell:scrollToOffset:)]) {
        [self.delegate didCourseListCell:self scrollToOffset:offset];
    }
}

@end
