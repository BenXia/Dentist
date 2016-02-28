//
//  FeedbackVC.m
//  Dentist
//
//  Created by Ben on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "FeedbackVC.h"
#import "FeedbackCell.h"
#import "ProductAppraiseDC.h"
#import "ProductListGoodsModel.h"

static NSString* const kCellReuseIdentifier = @"FeedbackCell";

@interface FeedbackVC () <
UITableViewDataSource,
UITableViewDelegate,
FeedbackCellDelegate,
PPDataControllerDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *feedbackModelsArray;

@property (nonatomic, strong) MultiPictureUploader *picturesUploader;
@property (nonatomic, strong) ProductAppraiseDC* dc;

@property (nonatomic, assign) BOOL statusBarHidden; // 需要控制状态栏隐藏和显示，在PhotosBrowserVC里面难以实现

@end

@implementation FeedbackVC

#pragma mark - View life cycle

-(instancetype)initWithOrderId:(NSString*)oid products:(NSArray*)products{
    if (self = [super init]) {
        self.title = @"评价晒单";
        self.picturesUploader = [[MultiPictureUploader alloc] init];
        self.dc = [[ProductAppraiseDC alloc]initWithDelegate:self];
        self.dc.oid = @(oid.intValue);
        
        self.feedbackModelsArray = [NSMutableArray new];
        for (ProductListGoodsModel* product in products) {
            FeedbackModel* model = [FeedbackModel new];
            model.product = product;
            model.imagesArray = [NSMutableArray new];
            model.imageUrls = [NSMutableArray new];
            [self.feedbackModelsArray addObject:model];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUIRelated];
}

- (BOOL)prefersStatusBarHidden {
    return _statusBarHidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)initUIRelated {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // NavigationBar
    [self setNavTitleString:@"评价晒单"];
    [self setNavLeftItemWithName:@"取消" target:self action:@selector(didClickOnLeftNavButtonAction:)];
    [self setNavRightItemWithName:@"发布" target:self action:@selector(didClickOnRightNavButtonAction:)];
    
    // TableView
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedbackCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kCellReuseIdentifier];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedbackModelsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FeedbackCell cellHeightWithModel:[self.feedbackModelsArray objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    cell.vc = self;
    [cell setupWithModel:[self.feedbackModelsArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - FeedbackCellDelegate

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    _statusBarHidden = statusBarHidden;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (void)needReloadData {
    [self.tableView reloadData];
}

#pragma mark - IBActions

- (void)didClickOnLeftNavButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickOnRightNavButtonAction:(id)sender {
    //检测必填数据
    for (int i= 0 ; i < self.feedbackModelsArray.count; ++i) {
        FeedbackModel* model = [self.feedbackModelsArray objectAtIndex:i];
        if (!model.starNumber) {
            [Utilities showToastWithText:[NSString stringWithFormat:@"请给第%d个商品打分",i+1]];
            return;
        }
        if (model.feedBackText.length <= 0) {
            [Utilities showToastWithText:[NSString stringWithFormat:@"请给第%d个商品评论",i+1]];
            return;
        }
    }
    
    //收集上传图片
    NSMutableArray *imagesToUpload = [NSMutableArray array];
    for (int i = 0; i < self.feedbackModelsArray.count; i++) {
        FeedbackModel *feedback = [self.feedbackModelsArray objectAtIndex:i];
        for (int j = 0; j < feedback.imagesArray.count; j++) {
            QQingImageView *imageView = [feedback.imagesArray objectAtIndex:j];
            [imagesToUpload addObject:imageView.imageView.image];
        }
    }
    
    //开始发送
    [Utilities showLoadingView];
    if (imagesToUpload.count > 0) {
        [self.picturesUploader uploadMultiImages:imagesToUpload
                                 imageUploadType:kImageUploadType_PhotoUploadType
                                         success:^(NSArray *array) {
                                             NSInteger index = 0;
                                             for (int i = 0; i < self.feedbackModelsArray.count && index < array.count; i++) {
                                                 FeedbackModel *feedback = [self.feedbackModelsArray objectAtIndex:i];
                                                 feedback.imageUrls = [NSMutableArray new];
                                                 for (int j = 0; j < feedback.imagesArray.count && index < array.count; j++) {
                                                     [feedback.imageUrls addObject:[array objectAtIndex:index++]];
                                                 }
                                             }
                                             
                                             [self sendAppraiseRequest];
                                             NSLog (@"array: %@", array);
                                         } fail:^(NSError *error) {
                                             [Utilities hideLoadingView];
                                             [Utilities showToastWithText:@"上传图片失败"];
                                             NSLog (@"error: %@", error);
                                         }];
    }else{
        [self sendAppraiseRequest];
    }
}

#pragma mark - Request 

-(void)sendAppraiseRequest{
    NSMutableArray* productIdArray = [NSMutableArray new]; //NSNumber数组
    NSMutableArray* scoreArray = [NSMutableArray new];
    NSMutableArray* contentArray = [NSMutableArray new];
    NSMutableArray* imageUrlArray = [NSMutableArray new];
    for (int i= 0 ; i < self.feedbackModelsArray.count; ++i) {
        FeedbackModel* model = [self.feedbackModelsArray objectAtIndex:i];
        
        [productIdArray addObject:@(model.product.productID.intValue)];
        [scoreArray addObject:model.starNumber];
        [contentArray addObject:model.feedBackText];
        
        if (model.imageUrls.count > 0) {
            NSMutableString* formatString = [NSMutableString new];
            for (NSString* imageUrl in model.imageUrls) {
                NSString* linkSymbol = formatString.length > 0 ? @"###" : @"";
                [formatString appendFormat:@"%@%@",linkSymbol,imageUrl];
            }
            [imageUrlArray addObject:formatString];
        }else{
            [imageUrlArray addObject:@""];
        }
    }
    
    self.dc.iid = productIdArray;
    self.dc.content = contentArray;
    self.dc.imgs = imageUrlArray;
    self.dc.score = scoreArray;
    
    [self.dc requestWithArgs:nil];
}


#pragma mark - PPDataControllerDelegate

//数据请求成功回调
- (void)loadingDataFinished:(PPDataController *)controller{
    [Utilities hideLoadingView];
    if (self.dc.appraiseSuccess) {
        [Utilities showToastWithText:@"评价成功"];
        [self postNotification:kNotificationAppraiseSuccess withObject:self.dc.oid];
    }else{
        NSString* message = self.dc.message.length > 0 ? self.dc.message : @"评价失败";
        [Utilities showToastWithText:message];
    }
}
//数据请求失败回调
- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error{
    [Utilities hideLoadingView];
    [Utilities showToastWithText:@"评价失败"];
}

@end
