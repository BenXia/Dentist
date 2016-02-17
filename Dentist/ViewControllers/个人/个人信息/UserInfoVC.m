//
//  UserInfoVC.m
//  Dentist
//
//  Created by 王涛 on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "UserInfoVC.h"
#import "UserInfoDC.h"
#import "UIImageView+WebCache.h"

@interface UserInfoVC () <UITableViewDataSource,
UITableViewDelegate,
PPDataControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UserInfoDC *userInfoRequest;
@property (strong, nonatomic) NSMutableArray *modelArray;
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
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"头像";
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 24 - 60 - 30, 12, 60, 60)];
        headImageView.layer.cornerRadius = 30;
        headImageView.layer.masksToBounds = YES;
        [headImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfoRequest.userInfoModel.headImagePath] placeholderImage:[UIImage imageNamed:@"imageDownloadFail.png"]];
        [cell.contentView addSubview:headImageView];
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

#pragma mark - PPDataControllerDelegate

- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error {
    if (controller == self.userInfoRequest) {
        [Utilities showToastWithText:[NSString stringWithFormat:@"获取个人信息失败:%@", error]];
        
    }
}

- (void)loadingDataFinished:(PPDataController *)controller {
    if (controller == self.userInfoRequest) {
        [[GCDQueue mainQueue] queueBlock:^{
            [self.tableView reloadData];
        }];
    }
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
