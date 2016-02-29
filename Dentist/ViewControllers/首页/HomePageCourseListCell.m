//
//  HomePageCourseListCell.m
//  StudioCommon
//
//  Created by Ben on 2/2/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "HomePageCourseListCell.h"

static NSArray* kHomePageCourseListSortArray;

NSString* const kHomePageCourseListCellIdentifier = @"HomePageCourseListCell";

@interface HomePageCourseListCell () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *clinicalBtn;
@property (weak, nonatomic) IBOutlet UILabel *clinicalLabel;
@property (weak, nonatomic) IBOutlet UIButton *mechanicBtn;
@property (weak, nonatomic) IBOutlet UILabel *mechanicLabel;
@property (weak, nonatomic) IBOutlet UIButton *custommadeBtn;
@property (weak, nonatomic) IBOutlet UILabel *custommadeLabel;
@property (weak, nonatomic) IBOutlet UIButton *lessonBtn;
@property (weak, nonatomic) IBOutlet UILabel *lessonLabel;

@end

@implementation HomePageCourseListCell

+ (void)initialize {
    [super initialize];
    
    kHomePageCourseListSortArray = @[@"临床", @"技工", @"定制套装", @"培训课程"];
}

- (void)awakeFromNib {
    [self.clinicalBtn setImage:[UIImage imageNamed:@"btn_clinical_pressed"] forState:UIControlStateSelected];
    [self.mechanicBtn setImage:[UIImage imageNamed:@"btn_mechanic_pressed"] forState:UIControlStateSelected];
    [self.custommadeBtn setImage:[UIImage imageNamed:@"btn_custommade_pressed"] forState:UIControlStateSelected];
    [self.lessonBtn setImage:[UIImage imageNamed:@"btn_lesson_pressed"] forState:UIControlStateSelected];
    self.clinicalLabel.textColor = [UIColor gray007Color];
    self.mechanicLabel.textColor = [UIColor gray007Color];
    self.custommadeLabel.textColor = [UIColor gray007Color];
    self.lessonLabel.textColor = [UIColor gray007Color];
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
}


#pragma mark - IBActions

- (IBAction)didClickOnMenuButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didCourseListCell:clickMenuTitle:)]) {
        NSString* title = [kHomePageCourseListSortArray objectAtIndexIfIndexInBounds:sender.tag];
        [self.delegate didCourseListCell:self clickMenuTitle:title];
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
