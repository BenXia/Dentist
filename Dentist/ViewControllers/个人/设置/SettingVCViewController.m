//
//  SettingVCViewController.m
//  Dentist
//
//  Created by 王涛 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "SettingVCViewController.h"
#import "AppDeinitializer.h"
#import "AboutUsVC.h"

@interface SettingVCViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SettingVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)initUI {
    self.title = @"设置";
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    [self.quitBtn liningThematized:[UIColor themeBlueColor]];
    self.quitBtn.layer.cornerRadius = 20;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                cell.textLabel.text = @"推荐给朋友";
            }
                break;
            case 1: {
                cell.textLabel.text = @"关于我们";
            }
                break;
            case 2: {
                cell.textLabel.text = @"联系我们";
            }
                break;
            case 3: {
                cell.textLabel.text = @"给我打分";
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0: {
                cell.textLabel.text = @"版本更新";
            }
                break;
            case 1: {
                cell.textLabel.text = @"清除缓存";
            }
            default:
                break;
        }

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                //cell.textLabel.text = @"推荐给朋友";
            }
                break;
            case 1: {
                AboutUsVC *aboutVC = [[AboutUsVC alloc] init];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
                break;
            case 2: {
                [Utilities makePhoneCall:@"4003335656"];
            }
                break;
            case 3: {
                //cell.textLabel.text = @"给我打分";
                
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0: {
                //cell.textLabel.text = @"版本更新";
            }
                break;
            case 1: {
                //cell.textLabel.text = @"清除缓存";
            }
            default:
                break;
        }
        
    }

}

#pragma mark - UIAction

- (IBAction)onQuitBtn:(UIButton *)sender {
    [[AppDeinitializer sharedInstance] cleanUpWhenLogout];
    [[MainViewManager sharedInstance] loadLoginVC];
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
