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
//TODO-GUO:测试
#import "ProductDetailVC.h"
#import "AllOrderListVC.h"


@interface ProfileVC ()<UITableViewDataSource,UITableViewDelegate,MyOrderCellDelegate>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userLevelImage;
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
    [self setNavRightItemWithImage:@"我的-设置按钮" target:self action:@selector(onSettingBtn)];
    [self initUI];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)refreshUI {
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfoModel sharedUserInfoModel].headPath] placeholderImage:[UIImage imageNamed:@"user_pic_boy"]];
    self.nickLabel.text = [UserInfoModel sharedUserInfoModel].nickName;
}

- (void)initUI {
    self.headImageView.layer.cornerRadius = self.headImageView.width/2;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickOnHeadImageView:)];
    [self.headImageView addGestureRecognizer:tap];
    [self refreshUI];
}

- (void)initTableView {
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registerNib:[MyOrderCell nib] forCellReuseIdentifier:[MyOrderCell identifier]];
}

#pragma mark - IBOut Action

- (IBAction)onShouCangBtn:(UIButton *)sender {
    
}

- (IBAction)onScanHistoryBtn:(UIButton *)sender {
}

- (IBAction)onAddressBtn:(UIButton *)sender {
    AddressListVC *addressListVC = [[AddressListVC alloc] initWithNibName:@"AddressListVC" bundle:nil];
    addressListVC.isSelectAddress = NO;
    addressListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addressListVC animated:YES];
}

- (void)onSettingBtn {
    NSLog(@"设置");
    
    //TODO-GUO:测试
    [self.navigationController pushViewController:[[ProductDetailVC alloc]initWithProductId:@"10"] animated:YES];
}

- (void)didClickOnHeadImageView:(UITapGestureRecognizer *)tap {
    UserInfoVC *userInfoVC = [[UserInfoVC alloc] initWithNibName:@"UserInfoVC" bundle:nil];
    userInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

#pragma mark - Navigation Style

- (UIColor*)preferNavBarBackgroundColor{
    return [UIColor themeBlueColor];
}

- (UIColor*)preferNavBarNormalTitleColor{
    return [UIColor whiteColor];
}

- (UIColor*)preferNavBarHighlightedTitleColor {
    return kWhiteHighlightedColor;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor gray005Color];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor gray006Color];
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.textLabel.text = @"我的订单";
            cell.detailTextLabel.text = @"查看全部";
        } else if (indexPath.section == 1) {
            cell.textLabel.text = @"客服热线";
            cell.detailTextLabel.text = @"400-8888-9990";
        } else if (indexPath.section == 2) {
            cell.textLabel.text = @"使用帮助";
            cell.detailTextLabel.text = @"";
        }
        return cell;
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
    AllOrderListVC * allOrderListVC = [AllOrderListVC new];
    allOrderListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allOrderListVC animated:YES];
}
@end
