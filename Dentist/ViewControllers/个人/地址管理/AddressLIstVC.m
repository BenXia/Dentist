//
//  AddressLIstVC.m
//  Dentist
//
//  Created by 王涛 on 16/2/21.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "AddressLIstVC.h"
#import "AddressListDC.h"

@interface AddressLIstVC ()<PPDataControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AddressListDC *addressListRequest;
@property (nonatomic, strong) WTLabel *blankLabel;
@end

@implementation AddressLIstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的地址";
    self.addressListRequest = [[AddressListDC alloc] initWithDelegate:self];
    [self.addressListRequest requestWithArgs:nil];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(didClickOnRightBtn)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (self.isSelectAddress) {
        cell.imageView.image = [UIImage imageWithColor:[UIColor gray001Color] andSize:CGSizeMake(20, 20)];
    }
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageWithColor:[UIColor themeBlueColor] andSize:CGSizeMake(20, 20)];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@     %@",address.recipientName,address.recipientPhoneNum];
    cell.detailTextLabel.text = address.detailAddress;
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Address *address = self.addressListRequest.addressArr[indexPath.row];
    if (self.isSelectAddress) {
        self.selectedCompleteBlock(address);
    } else {
        //地址编辑页
    }
}

#pragma mark - Action

- (void)didClickOnRightBtn {
    //跳新建地址页
    
}

#pragma mark - PPDataControllerDelegate

- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error {
    if (controller == self.addressListRequest) {
        [Utilities showToastWithText:[NSString stringWithFormat:@"获取地址列表失败:%@", error]];
    }
}

- (void)loadingDataFinished:(PPDataController *)controller {
    if (controller == self.addressListRequest) {
        [[GCDQueue mainQueue] queueBlock:^{
            [self.tableView reloadData];
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
        _blankLabel = [[WTLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 200) withTitle:@"没有任何未完成的课程" andSubTitle:@"找个老师来学习一下吧" andButtonTitle:nil andIcon:@"icoc_none01"];
        _blankLabel.y = kBlankOldY;
        _blankLabel.centerX = [UIUtils screenWidth]/2;
        [_blankLabel setButtonTitle:@"找老师"];
        _blankLabel.hidden = YES;
        [self.view addSubview:_blankLabel];
    }
    return _blankLabel;
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
