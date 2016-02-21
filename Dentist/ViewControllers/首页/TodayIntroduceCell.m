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
@property (weak, nonatomic) IBOutlet UIButton *leftImageShowBtn;

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
    for (ProductIntroduceModel *model in cellModel) {
        if ([model.location isEqualToString:@"右1"]) {
            [self.firstBtn sd_setImageWithURL:[NSURL URLWithString:model.img_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"btn_clinical_default.png"]];
            [self.firstBtn setTitle:model.event_id forState:UIControlStateNormal];
        } else if ([model.location isEqualToString:@"右2"]) {
            [self.secondBtn sd_setImageWithURL:[NSURL URLWithString:model.img_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"btn_clinical_default.png"]];
            [self.secondBtn setTitle:model.event_id forState:UIControlStateNormal];
        } else if ([model.location isEqualToString:@"左1"]) {
            [self.thirdBtn sd_setImageWithURL:[NSURL URLWithString:model.img_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"btn_clinical_default.png"]];
            [self.thirdBtn setTitle:model.event_id forState:UIControlStateNormal];
        } else if ([model.location isEqualToString:@"banner"]) {
            [self.fourthBtn sd_setImageWithURL:[NSURL URLWithString:model.img_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"btn_clinical_default.png"]];
            [self.fourthBtn setTitle:model.event_id forState:UIControlStateNormal];
        }
    }
    [self.firstBtn centerImageAndTitle];
    [self.secondBtn centerImageAndTitle];
    [self.thirdBtn centerImageAndTitle];
    [self.fourthBtn centerImageAndTitle];
}

#pragma mark - UI Action

- (IBAction)onFirstBtn:(UIButton *)sender {
    
}
- (IBAction)onSecondBtn:(UIButton *)sender {
    
}
- (IBAction)onThirdBtn:(UIButton *)sender {
    
}
- (IBAction)onFourthBtn:(UIButton *)sender {
    
}


@end
