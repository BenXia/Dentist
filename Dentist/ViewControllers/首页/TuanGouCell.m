//
//  TuanGouCell.m
//  Dentist
//
//  Created by 王涛 on 16/2/4.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "TuanGouCell.h"

@interface TuanGouCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstItemNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstImageBtn;

@property (weak, nonatomic) IBOutlet UILabel *secondItemNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *secondImageBtn;

@property (weak, nonatomic) IBOutlet UILabel *thirdItemLabel;
@property (weak, nonatomic) IBOutlet UIButton *thirdImageBtn;

@property (weak, nonatomic) IBOutlet UILabel *fourthItemNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *fourthImageBtn;


@end

@implementation TuanGouCell

- (void)awakeFromNib {
    self.timeLabel.text = @"还剩99:59:59";
    self.firstItemNameLabel.numberOfLines = 0;
    self.secondItemNameLabel.numberOfLines = 0;
    self.thirdItemLabel.numberOfLines = 0;
    self.fourthItemNameLabel.numberOfLines = 0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellModelArray:(NSArray *)cellModelArray {
    _cellModelArray = cellModelArray;
    NSMutableAttributedString *firstAttributeString = [[NSMutableAttributedString alloc] initWithString:@"橡胶结合剂研磨器XXX"
                                                                                          attributes:@{NSForegroundColorAttributeName:[UIColor gray007Color],
                                                                                                       NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    [firstAttributeString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n型号222"
                                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor gray004Color],
                                                                                                     NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}]];
    [firstAttributeString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n￥99.00"
                                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor redColor],
                                                                                                     NSFontAttributeName:[UIFont systemFontOfSize:16.0f]}]];
    
    for (int i = 0 ; i< cellModelArray.count; i++) {
        ProductIntroduceModel *model = cellModelArray[i];
        if (i == 0) {
            [self.firstImageBtn sd_setImageWithURL:[NSURL URLWithString:model.img_url] forState:UIControlStateNormal placeholderImage:nil];
        } else if (i == 1) {
            [self.secondImageBtn sd_setImageWithURL:[NSURL URLWithString:model.img_url] forState:UIControlStateNormal placeholderImage:nil];
        } else if (i == 2) {
            [self.thirdImageBtn sd_setImageWithURL:[NSURL URLWithString:model.img_url] forState:UIControlStateNormal placeholderImage:nil];
        } else if (i == 3) {
            [self.fourthImageBtn sd_setImageWithURL:[NSURL URLWithString:model.img_url] forState:UIControlStateNormal placeholderImage:nil];
        }
        
    }
    self.firstItemNameLabel.attributedText = firstAttributeString;
    self.secondItemNameLabel.attributedText = firstAttributeString;
    self.thirdItemLabel.attributedText = firstAttributeString;
    self.fourthItemNameLabel.attributedText = firstAttributeString;
    
}

@end
