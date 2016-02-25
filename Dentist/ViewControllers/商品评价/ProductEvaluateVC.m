//
//  ProductEvaluateVC.m
//  Dentist
//
//  Created by Ben on 2/21/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "ProductEvaluateVC.h"
#import "ProductEvaluateTableViewCell.h"
#import "ProductEvaluateVM.h"
#import "ProductEvaluateModel.h"
#import "ProductEvaluateDC.h"

@interface ProductEvaluateVC ()<PPDataControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  ProductEvaluateVM *productEvaluateVM;

@end

@implementation ProductEvaluateVC

- (instancetype)initWithProductId:(NSString *)productId {
    if (self = [super init]) {
        self.productEvaluateVM.productId = productId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initUI {
    self.title = @"商品评价";
    self.view.backgroundColor = [UIColor backGroundGrayColor];
}

- (void)initData {
    self.productEvaluateVM.productEvaluateDC = [[ProductEvaluateDC alloc] initWithDelegate:self];
    self.productEvaluateVM.productEvaluateDC.productId = self.productEvaluateVM.productId;
    [self.productEvaluateVM.productEvaluateDC requestWithArgs:nil];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.productEvaluateVM.productEvaluateDC.productEvaluateArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ProductEvaluateTableViewCell getCellHeightWithContent:[self.productEvaluateVM.productEvaluateDC.productEvaluateArray objectAtIndexIfIndexInBounds:indexPath.section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"ProductEvaluateTableViewCell";
    ProductEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductEvaluateTableViewCell" owner:nil options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ProductEvaluateModel *model = [self.productEvaluateVM.productEvaluateDC.productEvaluateArray objectAtIndex:indexPath.section];
    [cell setCellWithProductEvaluateModel:model];
    return cell;
}

#pragma mark - PPDataControllerDelegate

//数据请求成功回调
- (void)loadingDataFinished:(PPDataController *)controller{
    [self.tableView reloadData];
}

//数据请求失败回调
- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error{
    
    [Utilities showToastWithText:@"商品获取失败"];
}

#pragma mark - Data Init

- (ProductEvaluateVM *)productEvaluateVM {
    if (_productEvaluateVM == nil) {
        _productEvaluateVM = [ProductEvaluateVM new];
    }
    return _productEvaluateVM;
}

@end
