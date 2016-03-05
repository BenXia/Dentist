//
//  TuanGouCell.m
//  Dentist
//
//  Created by 王涛 on 16/2/4.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "TuanGouCell.h"

@interface TuanGouCell ()<SimpleCountdownDelegate>
@property (weak, nonatomic) IBOutlet UILabel *hhTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *mmTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *ssTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;

@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;

@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@property (weak, nonatomic) IBOutlet UIImageView *fourthImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) NSTimeInterval totalCountDownEndTimeInterval;

@property (strong, nonatomic) SimpleCountdown *totalCountDown;

@end

@implementation TuanGouCell

- (void)prepareForReuse {
    [self.totalCountDown cancel];
}

- (void)awakeFromNib {
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProductImage:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProductImage:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProductImage:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProductImage:)];
    [self.firstImageView addGestureRecognizer:tap1];
    [self.secondImageView addGestureRecognizer:tap2];
    [self.thirdImageView addGestureRecognizer:tap3];
    [self.fourthImageView addGestureRecognizer:tap4];
    
    self.hhTimeLabel.layer.cornerRadius = 3.0;
    self.hhTimeLabel.layer.masksToBounds = YES;
    
    self.mmTimeLabel.layer.cornerRadius = 3.0;
    self.mmTimeLabel.layer.masksToBounds = YES;
    
    self.ssTimeLabel.layer.cornerRadius = 3.0;
    self.ssTimeLabel.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellModelArray:(NSArray *)cellModelArray {
    _cellModelArray = cellModelArray;
    
    for (int i = 0 ; i< cellModelArray.count; i++) {
        ProductIntroduceModel *model = cellModelArray[i];
        if (i == 0) {
            [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"网络不给力-02.jpg"]];
        } else if (i == 1) {
            [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"网络不给力-02.jpg"]];
        } else if (i == 2) {
            [self.thirdImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"网络不给力-02.png"]];
        } else if (i == 3) {
            [self.fourthImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]placeholderImage:[UIImage imageNamed:@"网络不给力-02.jpg"]];
        }
        
    }
    
}

- (void)setEndTime:(long long)endTime {
    _endTime = endTime;
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    self.totalCountDownEndTimeInterval = [[NSString stringWithFormat:@"%.0f", endTime - currentTimeInterval] doubleValue];
    if (self.totalCountDownEndTimeInterval > 0) {
        [self startCountDown];
    }
}

-(void)startCountDown{
    self.totalCountDown = [[SimpleCountdown alloc] initWithTimeout:self.totalCountDownEndTimeInterval autoStart:NO];
    self.totalCountDown.delegate = self;
    self.totalCountDown.countdown = YES;
    [self.totalCountDown start];
}

#pragma mark - SimpleCountdownDelegate

- (BOOL)simpleCounter:(SimpleCountdown *)counter didCountingAt:(NSInteger)count{
    self.hhTimeLabel.text = [NSString stringWithFormat:@"%02ld",count/3600];
    self.mmTimeLabel.text = [NSString stringWithFormat:@"%02ld",count%3600/60];
    self.ssTimeLabel.text = [NSString stringWithFormat:@"%02ld",count%3600%60];
    if (count == 0) {
        self.titleLabel.text = @"活动已结束";
        [self postNotification:kNotificationActionOver];
        return NO;
    }
    return YES;
}


#pragma mark - UI Action

- (void) onProductImage:(UITapGestureRecognizer *)tap {
    if (tap.view == self.firstImageView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tuanGouCell:toProductDetailWith:)]) {
            ProductIntroduceModel *model = self.cellModelArray[0];
            [self.delegate tuanGouCell:self toProductDetailWith:model.iid];
        }
    } else if (tap.view == self.secondImageView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tuanGouCell:toProductDetailWith:)]) {
            ProductIntroduceModel *model = self.cellModelArray[1];
            [self.delegate tuanGouCell:self toProductDetailWith:model.iid];
        }
    } else if (tap.view == self.thirdImageView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tuanGouCell:toProductDetailWith:)]) {
            ProductIntroduceModel *model = self.cellModelArray[2];
            [self.delegate tuanGouCell:self toProductDetailWith:model.iid];
        }
    } else if (tap.view == self.fourthImageView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tuanGouCell:toProductDetailWith:)]) {
            ProductIntroduceModel *model = self.cellModelArray[3];
            [self.delegate tuanGouCell:self toProductDetailWith:model.iid];
        }
    }
}


@end
