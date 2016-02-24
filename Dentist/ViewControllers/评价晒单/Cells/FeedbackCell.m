//
//  FeedbackCell.m
//  Dentist
//
//  Created by Ben on 16/2/23.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "FeedbackCell.h"

@interface FeedbackCell () < UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContentViewHeightConstraint;

@property (weak, nonatomic) IBOutlet QQingImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCustomiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *star1Button;
@property (weak, nonatomic) IBOutlet UIButton *star2Button;
@property (weak, nonatomic) IBOutlet UIButton *star3Button;
@property (weak, nonatomic) IBOutlet UIButton *star4Button;
@property (weak, nonatomic) IBOutlet UIButton *star5Button;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starButtonsArray;

@property (weak, nonatomic) IBOutlet PlaceholderTextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UILabel *feedbackTextNumber;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;

@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;

@end

@implementation FeedbackCell

- (void)awakeFromNib {
    // Initialization code
    
    self.productImageView.layer.borderColor = RGB(237, 237, 237).CGColor;
    self.productImageView.layer.borderWidth = 1;
    
    self.productTitleLabel.numberOfLines = 0;
    
    self.feedbackTextView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Private methods

- (void)refreshStarButtonsArrayWithStarNumber:(NSInteger)starNumber {
    for (UIButton *button in self.starButtonsArray) {
        if ((button.tag - 100) <= starNumber) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }
}

#pragma mark - IBActions

- (IBAction)didClickStarButtonAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger starNumber = btn.tag - 100;
    
    if (btn.selected && (starNumber == 1) && (self.feedbackModel.starNumber == 1)) {
        [self refreshStarButtonsArrayWithStarNumber:0];
        self.feedbackModel.starNumber = 0;
    } else {
        [self refreshStarButtonsArrayWithStarNumber:starNumber];
        self.feedbackModel.starNumber = starNumber;
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] > 300) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"亲，字数不能超过300字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alert show];
        NSString *oldStr = textView.text;
        self.feedbackTextView.text = [oldStr substringToIndex:[oldStr length] - 1];
    } else {
        [self.feedbackTextNumber setText:[NSString stringWithFormat:@"%tu", [textView.text length]]];
        self.feedbackModel.feedBackText = self.feedbackTextView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark - Public methods

- (void)setupWithModel:(FeedbackModel *)feedbackModel {
    self.feedbackModel = feedbackModel;
    
    [self refreshStarButtonsArrayWithStarNumber:self.feedbackModel.starNumber];
    
    self.feedbackTextView.placeholder = @"写下心得，为其他小伙伴提供参考；字数300字内";
    self.feedbackTextView.placeholderType = PlaceholderType_Left;
    
    [self.feedbackTextView setText:self.feedbackModel.feedBackText];
    [self.feedbackTextNumber setText:[NSString stringWithFormat:@"%tu", [self.feedbackTextView.text length]]];
    
    [self.feedbackTextView setNeedsDisplay];
}

+ (CGFloat)cellHeightWithModel:(FeedbackModel *)feedbackModel {
    if (feedbackModel.imagesArray.count > 0) {
        return 285;
    } else {
        return 219;
    }
}

@end
