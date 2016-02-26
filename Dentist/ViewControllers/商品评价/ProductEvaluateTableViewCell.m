//
//  ProductEvaluateTableViewCell.m
//  Dentist
//
//  Created by Ben on 2/21/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "ProductEvaluateTableViewCell.h"
#import "ProductEvaluateModel.h"

#define kImageViewWidth    50
#define kImageViewHeight   50
#define kInsertSize        10
#define kImageViewTag      100


@interface ProductEvaluateTableViewCell()<QQingImageViewSingleClickDelegate,QQingPhotosBrowserVCDelegate>

@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIImageView *scoreImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *scoreImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *scoreImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *scoreImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *scoreImageView5;
@property (weak, nonatomic) IBOutlet UILabel *evaluateUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *evaluateContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *evaluateTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluateContentConstrainstHeight;

@property (strong, nonatomic) NSMutableArray *imageUrlArray;

@end


@implementation ProductEvaluateTableViewCell

- (void)awakeFromNib {
    self.topLineView.hidden = YES;
    self.imageUrlArray = [NSMutableArray new];
}

- (void)setTopLineViewHidden:(BOOL)hidden{
    self.topLineView.hidden = hidden;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCellWithProductEvaluateModel:(ProductEvaluateModel *)model {
    switch ([model.evaluateScore intValue]) {
        case 0: {
            self.scoreImageView1.image = [UIImage imageNamed:@"like_f"];
            self.scoreImageView2.image = [UIImage imageNamed:@"like_f"];
            self.scoreImageView3.image = [UIImage imageNamed:@"like_f"];
            self.scoreImageView4.image = [UIImage imageNamed:@"like_f"];
            self.scoreImageView5.image = [UIImage imageNamed:@"like_f"];
        }
            break;
        case 1: {
            self.scoreImageView1.image = [UIImage imageNamed:@"like_t"];
            self.scoreImageView2.image = [UIImage imageNamed:@"like_f"];
            self.scoreImageView3.image = [UIImage imageNamed:@"like_f"];
            self.scoreImageView4.image = [UIImage imageNamed:@"like_f"];
            self.scoreImageView5.image = [UIImage imageNamed:@"like_f"];
        }
            break;
        case 2: {
            self.scoreImageView1.image = [UIImage imageNamed:@"like_t"];
            self.scoreImageView2.image = [UIImage imageNamed:@"like_t"];
            self.scoreImageView3.image = [UIImage imageNamed:@"like_f"];
            self.scoreImageView4.image = [UIImage imageNamed:@"like_f"];
            self.scoreImageView5.image = [UIImage imageNamed:@"like_f"];
        }
            break;
        case 3: {
            self.scoreImageView1.image = [UIImage imageNamed:@"like_t"];
            self.scoreImageView2.image = [UIImage imageNamed:@"like_t"];
            self.scoreImageView3.image = [UIImage imageNamed:@"like_t"];
            self.scoreImageView4.image = [UIImage imageNamed:@"like_f"];
            self.scoreImageView5.image = [UIImage imageNamed:@"like_f"];
        }
            break;
        case 4: {
            self.scoreImageView1.image = [UIImage imageNamed:@"like_t"];
            self.scoreImageView2.image = [UIImage imageNamed:@"like_t"];
            self.scoreImageView3.image = [UIImage imageNamed:@"like_t"];
            self.scoreImageView4.image = [UIImage imageNamed:@"like_t"];
            self.scoreImageView5.image = [UIImage imageNamed:@"like_f"];
        }
            break;
        case 5: {
            self.scoreImageView1.image = [UIImage imageNamed:@"like_t"];
            self.scoreImageView2.image = [UIImage imageNamed:@"like_t"];
            self.scoreImageView3.image = [UIImage imageNamed:@"like_t"];
            self.scoreImageView4.image = [UIImage imageNamed:@"like_t"];
            self.scoreImageView5.image = [UIImage imageNamed:@"like_t"];
        }
            break;

        default:
            break;
    }
    
    self.evaluateUserNameLabel.text = model.evaluateUserName;
    self.evaluateContentLabel.text = model.evaluateContent;
    self.evaluateTimeLabel.text = model.evaluateTime;
    
    CGSize size = [model.evaluateContent textSizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kScreenWidth - 8 - 8, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    self.evaluateContentConstrainstHeight.constant = size.height;
    
    int oneLineImageViewMaxNumber = (kScreenWidth - kInsertSize)/(kImageViewWidth + kInsertSize);
    for (int index = 0; index < model.evaluateImageArray.count; index ++) {
        float x = kInsertSize + kInsertSize*(index%oneLineImageViewMaxNumber) + kImageViewWidth*(index%oneLineImageViewMaxNumber);
        
        int imageLineNumber = 0;
        if ( (index + 1) % oneLineImageViewMaxNumber ) {
            imageLineNumber = (index + 1)/oneLineImageViewMaxNumber + 1;
        } else {
            imageLineNumber = (index + 1)/oneLineImageViewMaxNumber;
        }

        float y = self.evaluateContentLabel.frame.origin.y+self.evaluateContentConstrainstHeight.constant + 8*imageLineNumber + kImageViewHeight*(imageLineNumber - 1);
        
        QQingImageView *imageView = [[QQingImageView alloc] initWithFrame:CGRectMake(x, y, kImageViewWidth, kImageViewHeight)];
        imageView.defaultImageName = @"user_pic_boy";
        imageView.tag = kImageViewTag + index;
        imageView.singleClickDelegate = self;
        imageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.imageURL = [NSURL URLWithString:[model.evaluateImageArray objectAtIndexIfIndexInBounds:index]];
        [self.contentView addSubview:imageView];
        [self.imageUrlArray addObject:[model.evaluateImageArray objectAtIndexIfIndexInBounds:index]];
    }
}

+ (float)getCellHeightWithContent:(ProductEvaluateModel *)model {
    CGSize size = [model.evaluateContent textSizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kScreenWidth - 8 - 8, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    int oneLineImageViewMaxNumber = (kScreenWidth - kInsertSize)/(kImageViewWidth + kInsertSize);
    
    int imageLineNumber = 0;
    if ( model.evaluateImageArray.count % oneLineImageViewMaxNumber ) {
        imageLineNumber = (int)model.evaluateImageArray.count/oneLineImageViewMaxNumber + 1;
    } else {
        imageLineNumber = (int)model.evaluateImageArray.count/oneLineImageViewMaxNumber;
    }
    
    return size.height + 84 - 21 + imageLineNumber*kImageViewHeight + imageLineNumber*kInsertSize;
}

#pragma mark - QQingImageViewSingleClickDelegate

- (void)didSingleClickImageView:(QQingImageView *)imageView {
    static BOOL s_inOpenAnimating = NO;    //避免多次点击，动画效果不正确
    if (s_inOpenAnimating) {
        return;
    }
    s_inOpenAnimating = YES;
    
    NSInteger index = imageView.tag - kImageViewTag;
    NSMutableArray *photosArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.imageUrlArray.count; i++) {
        EGOQuickPhoto *subPhoto = [[EGOQuickPhoto alloc] initWithImageURL:[NSURL URLWithString:self.imageUrlArray[i]]];
        [photosArray addObject:subPhoto];
    }
    
    EGOQuickPhotoSource *source = [[EGOQuickPhotoSource alloc] initWithPhotos:photosArray];
    QQingPhotosBrowserVC *photoController = [[QQingPhotosBrowserVC alloc] initWithPhotoSource:source];
    photoController.delegate = self;
    photoController.isEditMode = NO;
    photoController.pageIndex = index;
    
    [photoController showWithImageView:imageView withCompletion:^{
        s_inOpenAnimating = NO;
    }];
}

#pragma mark - QQingPhotosBrowserVCDelegate

- (BOOL)shouldShowCloseAnimation {
    return YES;
}

- (UIView *)imageViewContentViewForCloseAnimation {
    return self.contentView;
}

- (NSInteger)imageViewTagOffsetForCloseAnimation {
    return kImageViewTag;
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    if ([self.delegate respondsToSelector:@selector(setStatusBarHidden:)]) {
        [self.delegate setStatusBarHidden:statusBarHidden];
    }
}

@end
