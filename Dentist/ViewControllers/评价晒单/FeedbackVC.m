//
//  FeedbackVC.m
//  Dentist
//
//  Created by Ben on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "FeedbackVC.h"
#import "FeedbackCell.h"

static NSString* const kCellReuseIdentifier = @"FeedbackCell";

@interface FeedbackVC () <
UITableViewDataSource,
UITableViewDelegate,
FeedbackCellDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *feedbackModelsArray;

@property (nonatomic, strong) MultiPictureUploader *picturesUploader;

@property (nonatomic, assign) BOOL statusBarHidden; // 需要控制状态栏隐藏和显示，在PhotosBrowserVC里面难以实现

@end

@implementation FeedbackVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.picturesUploader = [[MultiPictureUploader alloc] init];
    [self initUIRelated];
    
    [self initDataSourceArray];
}

- (BOOL)prefersStatusBarHidden {
    return _statusBarHidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)initDataSourceArray {
    FeedbackModel *model1 = [[FeedbackModel alloc] init];
    model1.starNumber = 0;
    model1.feedBackText = @"";
    model1.imagesArray = [NSMutableArray array];
    
    FeedbackModel *model2 = [[FeedbackModel alloc] init];
    model2.starNumber = 0;
    model2.feedBackText = @"";
    model2.imagesArray = [NSMutableArray array];
    
    self.feedbackModelsArray = [NSMutableArray arrayWithObjects:model1, model2, nil];
    
    [self.tableView reloadData];
}

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
//    NSMutableArray *imagesToUpload = [NSMutableArray array];
//    
//    for (int i = 0; i < self.feedbackModelsArray.count; i++) {
//        FeedbackModel *feedback = [self.feedbackModelsArray objectAtIndex:i];
//        for (int j = 0; j < feedback.imagesArray.count; j++) {
//            QQingImageView *imageView = [feedback.imagesArray objectAtIndex:j];
//            [imagesToUpload addObject:imageView.imageView.image];
//        }
//    }
//    
//    [Utilities showLoadingView];
//    [self.picturesUploader uploadMultiImages:imagesToUpload
//                imageUploadType:kImageUploadType_PhotoUploadType
//                        success:^(NSArray *array) {
//                            [Utilities hideLoadingView];
//                            NSLog (@"array: %@", array);
//                        } fail:^(NSError *error) {
//                            [Utilities hideLoadingView];
//                            NSLog (@"error: %@", error);
//                        }];
}

@end
