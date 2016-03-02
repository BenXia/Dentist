//
//  ProfileVC.m
//  Dentist
//
//  Created by Ben on 16/1/10.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "ProfileVC.h"
#import "MyOrderCell.h"
#import "UserInfoVC.h"
#import "AddressListVC.h"
#import "MyFavoriteVC.h"
#import "LookHistoryVC.h"
#import "AllOrderListVC.h"
#import "AppDeinitializer.h"
#import "SettingVCViewController.h"


@interface ProfileVC ()<UITableViewDataSource,UITableViewDelegate,MyOrderCellDelegate>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIButton *userLevelBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProfileVC

#pragma mark - View life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的";
        self.tabBarItem.title = @"我的";
        self.tabBarItem.image = [UIImage imageNamed:@"btn_user_f"];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_user_t"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    [self refreshUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self clearNavLeftItem];
    [self setNavRightItemWithImage:@"设置" target:self action:@selector(onSettingBtn)];
    [self initUI];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public methods

- (void)showAllOrderListVC {
    AllOrderListVC * allOrderListVC = [[AllOrderListVC alloc] initWithOrderStatusType:OrderStatusType_NeedHandle];
    allOrderListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allOrderListVC animated:NO];
}

#pragma mark - Private methods

- (void)refreshUI {
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfoModel sharedUserInfoModel].headPath] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.nickLabel.text = [UserInfoModel sharedUserInfoModel].nickName;
}

- (void)initUI {
    [self.userLevelBtn liningThematized:[UIColor themeButtonBlueColor]];
    self.headImageView.layer.cornerRadius = self.headImageView.width/2;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickOnHeadImageView:)];
    [self.headerView addGestureRecognizer:tap];
    [self refreshUI];
}

- (void)initTableView {
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registerNib:[MyOrderCell nib] forCellReuseIdentifier:[MyOrderCell identifier]];
}

#pragma mark - IBOut Action

- (IBAction)onShouCangBtn:(UIButton *)sender {
    MyFavoriteVC* favoriteVC = [MyFavoriteVC new];
    favoriteVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:favoriteVC animated:YES];
}

- (IBAction)onScanHistoryBtn:(UIButton *)sender {
    LookHistoryVC* lookHistoryVC = [LookHistoryVC new];
    lookHistoryVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lookHistoryVC animated:YES];
}

- (IBAction)onAddressBtn:(UIButton *)sender {
    AddressListVC *addressListVC = [[AddressListVC alloc] initWithNibName:@"AddressListVC" bundle:nil];
    addressListVC.isSelectAddress = NO;
    addressListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addressListVC animated:YES];
}

- (void)onSettingBtn {
    SettingVCViewController *settingVC = [[SettingVCViewController alloc] initWithNibName:@"SettingVCViewController" bundle:nil];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)didClickOnHeadImageView:(UITapGestureRecognizer *)tap {
    UserInfoVC *userInfoVC = [[UserInfoVC alloc] initWithNibName:@"UserInfoVC" bundle:nil];
    userInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

#pragma mark - Navigation Style

//- (UIColor*)preferNavBarBackgroundColor{
//    return [UIColor themeBlueColor];
//}
//
//- (UIColor*)preferNavBarNormalTitleColor{
//    return [UIColor whiteColor];
//}

- (UIColor*)preferNavBarHighlightedTitleColor {
    return kWhiteHighlightedColor;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyOrderCell identifier] forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
        
    } else {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor gray005Color];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor gray006Color];
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.textLabel.text = @"我的订单";
            cell.detailTextLabel.text = @"查看全部";
        } else if (indexPath.section == 1) {
            cell.textLabel.text = @"客服热线";
            cell.detailTextLabel.text = @"400-001-4980";
        } else if (indexPath.section == 2) {
            cell.textLabel.text = @"使用帮助";
            cell.detailTextLabel.text = @"";
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        [Utilities makePhoneCall:@"4000014980"];
    } else if (indexPath.section == 0 && indexPath.row == 0){
        AllOrderListVC * allOrderListVC = [[AllOrderListVC alloc] initWithOrderStatusType:OrderStatusType_All];
        allOrderListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:allOrderListVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 90;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
#pragma mark - UITableViewCellDelegate

- (void)orderButtonClickedWithType:(OrderHandleType)orderHandleType {
    OrderStatusType orderType;
    switch (orderHandleType) {
        case OrderHandle_WaitingPay: {
            orderType = OrderStatusType_NeedHandle;
        }
            break;
        case OrderHandle_WaitingPraise: {
            orderType = OrderStatusType_NeedPraise;
        }
            break;
        case OrderHandle_Done: {
            orderType = OrderStatusType_Complete;
        }
            break;

        default:
            break;
    }

    AllOrderListVC * allOrderListVC = [[AllOrderListVC alloc] initWithOrderStatusType:orderType];
    allOrderListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allOrderListVC animated:YES];
}
@end
