//
//  AddressListVC.m
//  Dentist
//
//  Created by 王涛 on 16/2/21.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "AddressListVC.h"
#import "AddressListDC.h"
#import "CreateOrEditAddressVC.h"
#import "DeleteAddressDC.h"

@interface AddressListVC ()<PPDataControllerDelegate,
UITableViewDataSource,
UITableViewDelegate,
WTLabelDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AddressListDC *addressListRequest;
@property (nonatomic, strong) DeleteAddressDC *deleteAddressRequest;
@property (nonatomic, strong) WTLabel *blankLabel;
@property (nonatomic, strong) NSIndexPath *willDeleteIndexPath;
@property (nonatomic, strong) NSString *addressString;
@end

@implementation AddressListVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.addressListRequest = [[AddressListDC alloc] initWithDelegate:self];
    [self.addressListRequest requestWithArgs:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的地址";
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(didClickOnRightBtn)]];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressListRequest.addressArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Address *address = self.addressListRequest.addressArr[indexPath.row];
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    if (self.isSelectAddress) {
        cell.imageView.image = [UIImage imageNamed:@"btn_choice_f"];
        if (address.isDefault) {
            cell.imageView.image = [UIImage imageNamed:@"btn_choice_t"];
        }
    }
    self.addressString = [NSString stringWithFormat:@"%@%@%@%@",address.province,address.city,address.area,address.detailAddress];
    cell.textLabel.text = [NSString stringWithFormat:@"%@     %@",address.recipientName,address.recipientPhoneNum];
    cell.detailTextLabel.text = self.addressString;
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44 + [self.addressString textSizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kScreenWidth - 50, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Address *address = self.addressListRequest.addressArr[indexPath.row];
    if (self.isSelectAddress) {
        self.selectedCompleteBlock(address);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //地址编辑页
        CreateOrEditAddressVC *creatAddressVC = [[CreateOrEditAddressVC alloc] initWithNibName:@"CreateOrEditAddressVC" bundle:nil];
        creatAddressVC.type = kAddressToChange;
        creatAddressVC.addressModel = address;
        [self.navigationController pushViewController:creatAddressVC animated:YES];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSelectAddress) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
    
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Address *address = self.addressListRequest.addressArr[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.deleteAddressRequest = [[DeleteAddressDC alloc] initWithDelegate:self];
        self.deleteAddressRequest.aid = address.ID;
        [self.deleteAddressRequest requestWithArgs:nil];
        self.willDeleteIndexPath = indexPath;
    }
}

#pragma mark - Action

- (void)didClickOnRightBtn {
    //跳新建地址页
    CreateOrEditAddressVC *creatAddressVC = [[CreateOrEditAddressVC alloc] initWithNibName:@"CreateOrEditAddressVC" bundle:nil];
    creatAddressVC.type = kAddressToAdd;
    [self.navigationController pushViewController:creatAddressVC animated:YES];
}

#pragma mark - PPDataControllerDelegate

- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error {
    if (controller == self.addressListRequest) {
        [Utilities showToastWithText:[NSString stringWithFormat:@"获取地址列表失败"]];
    } else if (controller == self.deleteAddressRequest) {
        [Utilities showToastWithText:[NSString stringWithFormat:@"删除地址失败"]];
    }
}

- (void)loadingDataFinished:(PPDataController *)controller {
    if (controller == self.addressListRequest) {
        [[GCDQueue mainQueue] queueBlock:^{
            [self refreshTableView];
        }];
    } else if (controller == self.deleteAddressRequest) {
        [[GCDQueue mainQueue] queueBlock:^{
            [self.addressListRequest.addressArr removeObjectAtIndex:self.willDeleteIndexPath.row];
            [self refreshTableView];
        }];
    }
}

#pragma mark - Private Method

- (void)refreshTableView {
    if (self.addressListRequest.addressArr.count>0) {
        self.blankLabel.hidden = YES;
        [self.tableView reloadData];
    } else {
        self.blankLabel.hidden = NO;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollViewOffY = scrollView.contentOffset.y;
    self.blankLabel.y = kBlankOldY - scrollViewOffY;
}

#pragma mark - Setters and Getters

- (WTLabel *)blankLabel {
    if (!_blankLabel) {
        _blankLabel = [[WTLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 200) withTitle:@"还没有地址" andSubTitle:@"新添加一个地址吧" andButtonTitle:nil andIcon:@"头像"];
        _blankLabel.y = kBlankOldY;
        _blankLabel.centerX = [UIUtils screenWidth]/2;
        [_blankLabel setButtonTitle:@"新建"];
        [_blankLabel.btn liningThematized:[UIColor themeButtonBlueColor]];
        _blankLabel.delegate = self;
        _blankLabel.hidden = YES;
        [self.view addSubview:_blankLabel];
    }
    return _blankLabel;
}

#pragma mark - WTLabelDelegate

- (void)didClickOnBtn {
    [self didClickOnRightBtn];
}

@end
