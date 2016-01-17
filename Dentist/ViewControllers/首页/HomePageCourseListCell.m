//
//  HomePageCourseListCell.m
//  QQing
//
//  Created by Ben on 15/11/26.
//
//

#import "HomePageCourseListCell.h"

static const CGFloat kCourseItemOffsetX = 10;
static const CGFloat kCourseItemHorizontalGap = 10;
static const CGFloat kCourseItemWidth = 70;
static const CGFloat kCourseItemHeight = 60;

static NSArray* kHomePageCourseListSortArray;

NSString* const kHomePageCourseListCellIdentifier = @"HomePageCourseListCell";

@interface HomePageCourseListCell () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewWidthConstaint;

@end

@implementation HomePageCourseListCell

+ (void)initialize {
    [super initialize];
    
    kHomePageCourseListSortArray = @[@"数学", @"英语", @"语文", @"物理", @"化学", @"生物", @"政治", @"历史", @"地理", @"奥数"];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.scrollContentView removeAllSubviews];
}

- (void)reloadData {
    [self.scrollContentView removeAllSubviews];
    
    NSArray *courseArray = @[@"1",@"2",@"3",@"4"];
    self.scrollContentViewWidthConstaint.constant = kCourseItemOffsetX + (kCourseItemWidth + kCourseItemHorizontalGap) * courseArray.count;
    
    for (int i = 0; i < courseArray.count; i++) {
        NSString *courseModel = [courseArray objectAtIndexIfIndexInBounds:i];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kCourseItemOffsetX + i * (kCourseItemWidth + kCourseItemHorizontalGap), 10, kCourseItemWidth, kCourseItemHeight)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"bg_class"] forState:UIControlStateNormal];
        [button setTitle:courseModel forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18.f];
        button.tag = courseModel;
        [button addTarget:self action:@selector(didClickOnCourseButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollContentView addSubview:button];
    }
    
#ifdef DEBUG
    self.scrollContentViewWidthConstaint.constant = kCourseItemOffsetX + (kCourseItemWidth + kCourseItemHorizontalGap) * (courseArray.count + 1);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kCourseItemOffsetX + courseArray.count * (kCourseItemWidth + kCourseItemHorizontalGap), 10, kCourseItemWidth, kCourseItemHeight)];
    [button setTitleColor:[UIColor gray007Color] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"pic_index_qq02"] forState:UIControlStateNormal];
    [button setTitle:@"测试" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    button.tag = 0;
    [button addTarget:self action:@selector(didClickOnTestButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollContentView addSubview:button];
#endif
}

#pragma mark - IBActions

- (void)didClickOnCourseButton:(UIButton *)courseButton {
    if ([self.delegate respondsToSelector:@selector(didSelectCourseWithId:)]) {
        [self.delegate didSelectCourseWithId:(int)courseButton.tag];
    }
}

- (void)didClickOnTestButton:(UIButton *)testButton {
    if ([self.delegate respondsToSelector:@selector(didClickOnTestButtonAction:)]) {
        [self.delegate didClickOnTestButtonAction:testButton];
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
