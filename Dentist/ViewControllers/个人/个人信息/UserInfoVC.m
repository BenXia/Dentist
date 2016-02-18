//
//  UserInfoVC.m
//  Dentist
//
//  Created by 王涛 on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import<AssetsLibrary/ALAssetsLibrary.h>
#import "UserInfoVC.h"
#import "UserInfoDC.h"
#import "UIImageView+WebCache.h"
#import "ChangeUserHeadImageDC.h"

@interface UserInfoVC () <UITableViewDataSource,
UITableViewDelegate,
PPDataControllerDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UserInfoDC *userInfoRequest;
@property (strong, nonatomic) ChangeUserHeadImageDC *changeUserHeadRequest;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (strong, nonatomic) UIImageView *headImageView;

@end

@implementation UserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.userInfoRequest = [[UserInfoDC alloc] initWithDelegate:self];
    [self.userInfoRequest requestWithArgs:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor gray005Color];
        cell.detailTextLabel.textColor = [UIColor gray006Color];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"头像";
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfoRequest.userInfoModel.headImagePath] placeholderImage:[UIImage imageNamed:@"imageDownloadFail.png"]];
        [cell.contentView addSubview:self.headImageView];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.text = self.userInfoRequest.userInfoModel.nick;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"绑定手机号";
        cell.detailTextLabel.text = self.userInfoRequest.userInfoModel.phoneNum;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"我的地址";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self changeUserHead];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 84;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

#pragma mark - Private method

- (void)changeUserHead {
    UIActionSheet *userSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil ];
    [userSheet showInView:self.view];
}

#pragma mark ----------ActionSheet 按钮点击-------------

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            // 照一张
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if (authStatus == AVAuthorizationStatusNotDetermined) {
                [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {}];
                return;
            } else if(authStatus != AVAuthorizationStatusAuthorized) {
                [UIUtils showAlertView:nil :@"请在iPhone的“设置－隐私－相机”选项中，允许轻轻访问您的手机相机。" :@"我知道了"];
                return;
            }
            
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        }
            break;
            
        case 1: {
            // 相册搞一张
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author != ALAuthorizationStatusAuthorized && author != ALAuthorizationStatusNotDetermined) {
                // 用户不允许应用访问相册
                [UIUtils showAlertView:nil :@"请在iPhone的“设置－隐私－照片”选项中，允许轻轻访问您的手机相册。" :@"我知道了"];
                return;
            }
            
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc] init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* image =[info objectForKey:UIImagePickerControllerEditedImage];
    // 回到当前页面
    @weakify(self);
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        //上传头像接口
        self.changeUserHeadRequest = [[ChangeUserHeadImageDC alloc] initWithDelegate:self];
        self.changeUserHeadRequest.headImage = image;
        [self.changeUserHeadRequest requestWithArgs:nil];
    }];
}

#pragma mark - PPDataControllerDelegate

- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error {
    if (controller == self.userInfoRequest) {
        [Utilities showToastWithText:[NSString stringWithFormat:@"获取个人信息失败:%@", error]];
    } else if (controller == self.changeUserHeadRequest) {
        [Utilities showToastWithText:[NSString stringWithFormat:@"设置头像失败:%@", error]];
    }
}

- (void)loadingDataFinished:(PPDataController *)controller {
    if (controller == self.userInfoRequest) {
        [[GCDQueue mainQueue] queueBlock:^{
            [self.tableView reloadData];
        }];
    }else if (controller == self.changeUserHeadRequest) {
        if (self.changeUserHeadRequest.responseCode == 200) {
            [Utilities showToastWithText:[NSString stringWithFormat:@"头像设置成功"]];
        }
    }
}

#pragma mark - setters and getters

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 24 - 60 - 30, 12, 60, 60)];
        _headImageView.layer.cornerRadius = 30;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
