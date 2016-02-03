//
//  TodayIntroduceCell.m
//  Dentist
//
//  Created by 王涛 on 16/2/3.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "TodayIntroduceCell.h"

@interface TodayIntroduceCell ()
@property (weak, nonatomic) IBOutlet UIView *leftBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;

@end

@implementation TodayIntroduceCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = [UIColor backGroundGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellModel:(id)cellModel {
    _cellModel = cellModel;
    [self.firstBtn setImage:[UIImage imageNamed:@"btn_clinical_pressed"] forState:UIControlStateNormal];
    [self.secondBtn setImage:[UIImage imageNamed:@"btn_clinical_pressed"] forState:UIControlStateNormal];
    [self.thirdBtn setImage:[UIImage imageNamed:@"btn_clinical_pressed"] forState:UIControlStateNormal];
    [self.fourthBtn setImage:[UIImage imageNamed:@"btn_clinical_pressed"] forState:UIControlStateNormal];
//    [self.firstBtn centerImageAndTitle];
//    [self.secondBtn centerImageAndTitle];
//    [self.thirdBtn centerImageAndTitle];
//    [self.fourthBtn centerImageAndTitle];
}

@end
