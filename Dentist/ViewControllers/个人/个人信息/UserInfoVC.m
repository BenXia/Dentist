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
#import "SetNickVC.h"
#import "AddressListVC.h"

@interface UserInfoVC () <UITableViewDataSource,
UITableViewDelegate,
PPDataControllerDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UserInfoDC *userInfoRequest;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UIImage *uploadImage;

@end

@implementation UserInfoVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
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
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfoModel sharedUserInfoModel].headPath] placeholderImage:[UIImage imageNamed:@"头像"]];
        [cell.contentView addSubview:self.headImageView];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.text = [UserInfoModel sharedUserInfoModel].nickName;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"绑定手机号";
        cell.detailTextLabel.text = [UserInfoModel sharedUserInfoModel].mobile;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"我的地址";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self changeUserHead];
    } else if (indexPath.row == 1) {
        SetNickVC *setNickVC = [[SetNickVC alloc] initWithNibName:@"SetNickVC" bundle:nil];
        setNickVC.nick = [UserInfoModel sharedUserInfoModel].nickName;
        [self.navigationController pushViewController:setNickVC animated:YES];
    } else if (indexPath.row == 3) {
        AddressListVC *addressListVC = [[AddressListVC alloc] initWithNibName:@"AddressListVC" bundle:nil];
        addressListVC.isSelectAddress = NO;
        addressListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressListVC animated:YES];
        
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
    self.uploadImage = image;
    // 回到当前页面
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //上传头像接口
        [[[PictureUploader alloc] init] uploadPicture:image
                                      imageUploadType:kImageUploadType_HeadimgUploadType
                                              success:^(id obj) {
            [[GCDQueue mainQueue] queueBlock:^{
                //更新缓存
                [Utilities showToastWithText:@"头像上传成功"];
                [UserInfoModel sharedUserInfoModel].headPath = obj;
                [self.headImageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"user_pic_boy"]];
            }];
        } fail:^(NSError *error) {
            [[GCDQueue mainQueue] queueBlock:^{
                [Utilities showToastWithText:@"头像上传失败"];
            }];
            
        } progress:^(CGFloat afloat) {
            
        }];
    }];
}

#pragma mark - PPDataControllerDelegate

- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error {
    if (controller == self.userInfoRequest) {
        [Utilities showToastWithText:[NSString stringWithFormat:@"获取个人信息失败"]];
    }
}

- (void)loadingDataFinished:(PPDataController *)controller {
    if (controller == self.userInfoRequest) {
        [[GCDQueue mainQueue] queueBlock:^{
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - public method




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
