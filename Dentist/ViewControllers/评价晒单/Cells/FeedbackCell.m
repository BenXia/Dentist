//
//  FeedbackCell.m
//  Dentist
//
//  Created by Ben on 16/2/23.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "FeedbackCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "QQingPhotosBrowserVC.h"
#import "ELCImagePickerController.h"

#pragma mark - 图片浏览器编辑模式需要使用的常量

static const NSInteger kMaxImageCount = 2;
static const NSInteger kEditModeTagOffset = 1000;
static const CGFloat kEditModeOriginX = 10;
static const CGFloat kEditModeOriginY = 10;
static const CGFloat kEditModeHorizontalGap = 10;
static const CGFloat kEditModeImageWidth = 45;
static const CGFloat kEditModeImageHeight = 45;

@interface FeedbackCell () <
UITextViewDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
ELCImagePickerControllerDelegate,
QQingImageViewSingleClickDelegate,
QQingPhotosBrowserVCDelegate
>

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

#pragma mark - 图片浏览器

@property (weak, nonatomic) IBOutlet UIView *editContentView;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addImageButtonLeadingConstraint;

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

- (void)refreshFeedbackPhotosUI {
    for (UIView *subview in self.editContentView.subviews) {
        if ([subview isKindOfClass:[QQingImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    for (NSInteger i = 0; i < self.feedbackModel.imagesArray.count; i++) {
        QQingImageView *imageView = [self.feedbackModel.imagesArray objectAtIndex:i];
        
        [imageView setFrame:CGRectMake(kEditModeOriginX + i * (kEditModeImageWidth + kEditModeHorizontalGap), kEditModeOriginY, kEditModeImageWidth, kEditModeImageHeight)];
        imageView.singleClickDelegate = self;
        imageView.tag = i + kEditModeTagOffset;
        
        [self.editContentView addSubview:imageView];
    }
    
    if (self.feedbackModel.imagesArray.count >= kMaxImageCount) {
        self.addImageButton.hidden = YES;
    } else {
        self.addImageButton.hidden = NO;
        self.addImageButtonLeadingConstraint.constant = kEditModeOriginX + self.feedbackModel.imagesArray.count * (kEditModeImageWidth + kEditModeHorizontalGap);
    }
}

#pragma mark - IBActions

- (IBAction)didClickStarButtonAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger starNumber = btn.tag - 100;
    
    if (btn.selected && (starNumber == 1) && (self.feedbackModel.starNumber.intValue == 1)) {
        [self refreshStarButtonsArrayWithStarNumber:0];
        self.feedbackModel.starNumber = @(0);
    } else {
        [self refreshStarButtonsArrayWithStarNumber:starNumber];
        self.feedbackModel.starNumber = @(starNumber);
    }
}

- (IBAction)didClickTakePhotoButtonAction:(id)sender {
    [self.feedbackTextView resignFirstResponder];
    
    if (self.feedbackModel.imagesArray.count >= kMaxImageCount) {
        [Utilities showToastWithText:@"最多支持两张图片" withImageName:nil blockUI:NO];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
        [actionSheet showInView:self.vc.view];
    }
}

- (IBAction)didClickAddImageButtonAction:(id)sender {
    [self.feedbackTextView resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
    [actionSheet showInView:self.vc.view];
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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            [self pickImageFromAlbumAction];
            break;
        }
            
        case 1: {
            [self pickImageFromCameraAction];
            break;
        }
            
        default: {
            break;
        }
    }
}

#pragma mark - ELCImagePicker related

- (void)pickImageFromAlbumAction {
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = kMaxImageCount - self.feedbackModel.imagesArray.count; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIImage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image   //(NSString *)kUTTypeMovie
    elcPicker.imagePickerDelegate = self;
    
    [self.vc presentViewController:elcPicker animated:YES completion:nil];
}

#pragma mark - ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    [self.vc dismissViewControllerAnimated:YES completion:^{
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
        for (NSDictionary *dict in info) {
            if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto) {
                //UIImage* image=[dict objectForKey:UIImagePickerControllerEditedImage];
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                if (image){
                    [images addObject:image];
                } else {
                    QQLog(@"返回错误图片资源:%@", dict);
                }
            } else {
                QQLog(@"未知文件格式");
            }
        }
        
        for (UIImage *image in images) {
            NSInteger currentImageCount = self.feedbackModel.imagesArray.count;
            QQingImageView *imageView = [[QQingImageView alloc] initWithFrame:CGRectMake(kEditModeOriginX + currentImageCount * (kEditModeImageWidth + kEditModeHorizontalGap), kEditModeOriginY, kEditModeImageWidth, kEditModeImageHeight)];
            imageView.imageView.backgroundColor = [UIColor clearColor];
            imageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.imageView.image = [image compressImageWithJPGCompression:0.75];
            imageView.singleClickDelegate = self;
            imageView.tag = currentImageCount + kEditModeTagOffset;
            
            [self.editContentView addSubview:imageView];
            [self.feedbackModel.imagesArray addObject:imageView];
            if ([self.delegate respondsToSelector:@selector(needReloadData)]) {
                [self.delegate needReloadData];
            }
            
            if (self.feedbackModel.imagesArray.count >= kMaxImageCount) {
                self.addImageButton.hidden = YES;
            } else {
                self.addImageButton.hidden = NO;
                self.addImageButtonLeadingConstraint.constant = kEditModeOriginX + self.feedbackModel.imagesArray.count * (kEditModeImageWidth + kEditModeHorizontalGap);
            }
        }
    }];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self.vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerController related

- (void)pickImageFromCameraAction {
#if !TARGET_IPHONE_SIMULATOR
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"设备无摄像头"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *mediaType = AVMediaTypeVideo; // Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        __weak FeedbackCell *weakSelf = self;
        
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if (granted) {
                [weakSelf pickImageFromCamera];
            }
        }];
    } else if (authStatus != AVAuthorizationStatusAuthorized) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在iPhone的“设置－隐私－相机”选项中，允许轻轻家教访问您的手机相机。"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
    } else {
        [self pickImageFromCamera];
    }
#endif
}

- (void)pickImageFromCamera {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    [self.vc presentViewController:imagePicker animated:YES completion:^{ }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image= [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    [self.vc dismissViewControllerAnimated:YES completion:^{
        NSInteger currentImageCount = self.feedbackModel.imagesArray.count;
        QQingImageView *imageView = [[QQingImageView alloc] initWithFrame:CGRectMake(kEditModeOriginX + currentImageCount * (kEditModeImageWidth + kEditModeHorizontalGap), kEditModeOriginY, kEditModeImageWidth, kEditModeImageHeight)];
        imageView.imageView.backgroundColor = [UIColor clearColor];
        imageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.imageView.image = [image compressImageWithJPGCompression:0.75];
        imageView.singleClickDelegate = self;
        imageView.tag = currentImageCount + kEditModeTagOffset;
        
        [self.editContentView addSubview:imageView];
        [self.feedbackModel.imagesArray addObject:imageView];
        if ([self.delegate respondsToSelector:@selector(needReloadData)]) {
            [self.delegate needReloadData];
        }
        
        if (self.feedbackModel.imagesArray.count >= kMaxImageCount) {
            self.addImageButton.hidden = YES;
        } else {
            self.addImageButton.hidden = NO;
            self.addImageButtonLeadingConstraint.constant = kEditModeOriginX + self.feedbackModel.imagesArray.count * (kEditModeImageWidth + kEditModeHorizontalGap);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.vc dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - QQingImageViewSingleClickDelegate

- (void)didSingleClickImageView:(QQingImageView *)imageView {
    static BOOL s_inOpenAnimating = NO;    //避免多次点击，动画效果不正确
    if (s_inOpenAnimating) {
        return;
    }
    s_inOpenAnimating = YES;
    
    NSMutableArray *photosArray = [NSMutableArray array];
    NSUInteger index = imageView.tag - kEditModeTagOffset;
    
    NSUInteger imagesCount = self.feedbackModel.imagesArray.count;
    for (NSInteger i = 0; i < imagesCount; i++) {
        QQingImageView *subImageView = [self.feedbackModel.imagesArray objectAtIndexIfIndexInBounds:i];
        EGOQuickPhoto *subPhoto = [[EGOQuickPhoto alloc] initWithImage:subImageView.imageView.image];
        [photosArray addObject:subPhoto];
    }
    
    EGOQuickPhotoSource *source = [[EGOQuickPhotoSource alloc] initWithPhotos:photosArray];
    QQingPhotosBrowserVC *photoController = [[QQingPhotosBrowserVC alloc] initWithPhotoSource:source];
    photoController.delegate = self;
    photoController.isEditMode = YES;
    photoController.pageIndex = index;
    
    [photoController showWithImageView:imageView withCompletion:^{
        s_inOpenAnimating = NO;
    }];
}

#pragma mark - QQingPhotosBrowserVCDelegate

- (void)willCloseVCWithPhotoSource:(id <EGOPhotoSource>)aPhotoSource {
    for (UIView *subview in self.editContentView.subviews) {
        if ([subview isKindOfClass:[QQingImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    [self.feedbackModel.imagesArray removeAllObjects];
    
    for (NSInteger i = 0; i < [aPhotoSource numberOfPhotos]; i++) {
        EGOQuickPhoto *photo = [aPhotoSource photoAtIndex:i];
        
        NSInteger currentImageCount = self.feedbackModel.imagesArray.count;
        QQingImageView *imageView = [[QQingImageView alloc] initWithFrame:CGRectMake(kEditModeOriginX + currentImageCount * (kEditModeImageWidth + kEditModeHorizontalGap), kEditModeOriginY, kEditModeImageWidth, kEditModeImageHeight)];
        imageView.imageView.backgroundColor = [UIColor clearColor];
        imageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.imageView.image = photo.image;
        imageView.singleClickDelegate = self;
        imageView.tag = currentImageCount + kEditModeTagOffset;
        
        [self.editContentView addSubview:imageView];
        [self.feedbackModel.imagesArray addObject:imageView];
        if ([self.delegate respondsToSelector:@selector(needReloadData)]) {
            [self.delegate needReloadData];
        }
    }
    
    if (self.feedbackModel.imagesArray.count >= kMaxImageCount) {
        self.addImageButton.hidden = YES;
    } else {
        self.addImageButton.hidden = NO;
        self.addImageButtonLeadingConstraint.constant = kEditModeOriginX + self.feedbackModel.imagesArray.count * (kEditModeImageWidth + kEditModeHorizontalGap);
    }
}

- (BOOL)shouldShowCloseAnimation {
    return YES;
}

- (UIView *)imageViewContentViewForCloseAnimation {
    return self.editContentView;
}

- (NSInteger)imageViewTagOffsetForCloseAnimation {
    return kEditModeTagOffset;
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    if ([self.delegate respondsToSelector:@selector(setStatusBarHidden:)]) {
        [self.delegate setStatusBarHidden:statusBarHidden];
    }
}

#pragma mark - Public methods

- (void)setupWithModel:(FeedbackModel*)feedbackModel {
    self.feedbackModel = feedbackModel;
    
    [self.productImageView setImageURL:[NSURL URLWithString:feedbackModel.product.productImageUrl]];
    self.productTitleLabel.text = feedbackModel.product.productTitle;
    self.priceLabel.text = [NSString stringWithFormat:@"%@%.2f",kYuanSymbolStr,feedbackModel.product.productPrice.floatValue];
    self.productCustomiseLabel.text = feedbackModel.product.productModel;
    self.productNumberLabel.text = [NSString stringWithFormat:@"x%@",feedbackModel.product.productNumber];
    
    [self refreshStarButtonsArrayWithStarNumber:self.feedbackModel.starNumber.integerValue];
    
    self.feedbackTextView.placeholder = @"写下心得，为其他小伙伴提供参考；字数300字内";
    self.feedbackTextView.placeholderType = PlaceholderType_Left;
    
    [self.feedbackTextView setText:self.feedbackModel.feedBackText];
    [self.feedbackTextNumber setText:[NSString stringWithFormat:@"%tu", [self.feedbackTextView.text length]]];
    
    [self.feedbackTextView setNeedsDisplay];
    
    [self refreshFeedbackPhotosUI];
}

+ (CGFloat)cellHeightWithModel:(FeedbackModel *)feedbackModel {
    if (feedbackModel.imagesArray.count > 0) {
        return 285;
    } else {
        return 219;
    }
}

@end
