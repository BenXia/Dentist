//
//  CartVC.m
//  Dentist
//
//  Created by Ben on 16/1/10.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "CartVC.h"
#import "ProductBriefInfoCell.h"
#import "ProductDetailVC.h"
#import "OrderVC.h"
#import "WebBrowserVC.h"
#import "PaySuccessVC.h"
#import "PayFailedVC.h"
#import "FeedbackVC.h"
#import "ShoppingCardVM.h"
#import "ShoppingCartModel.h"

static NSString* const kCellReuseIdentifier = @"ProductBriefInfoCell";

@interface CartVC () <UITableViewDataSource, UITableViewDelegate,ProductBriefInfoCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;
@property (weak, nonatomic) IBOutlet UIView *bottomSubContentView1;
@property (weak, nonatomic) IBOutlet UIView *bottomSubContentView2;
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *moveToFavoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (strong, nonatomic)        UILabel  *totalCountLabel;

@property (strong, nonatomic) ShoppingCardVM *shoppingCardVM;

@property (assign, nonatomic) BOOL isEditType;

@end

@implementation CartVC

#pragma mark - View life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"购物车";
        self.tabBarItem.image = [UIImage imageNamed:@"btn_cart_f"];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_cart_t"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.isEditType = NO;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    ShoppingCartModel *model = [ShoppingCartModel new];
    model.shoppingCartProductID = @"100";
    model.shoppingCartProductNumber = @"2";
    model.shoppingCartProductSids = @"颜色:黄色;型号:cw 1224m";
    model.shoppingCartProductPrice = @"200";
    model.shoppingCartProductSurplusNumber = @"200";
    model.shoppingCartProductIsDel = @"0";
    model.shoppingCartProductTitle = @"我是宝贝标题可以这行卧室宝贝标题可以这行客厅厕所厨房";
    model.shoppingCartProductImage = @"http://g.hiphotos.baidu.com/image/pic/item/d788d43f8794a4c2b3e5d2140df41bd5ac6e39ce.jpg";
    model.shoppingCartProductBuyCert = @"0";
    
    
    
    ShoppingCartModel *model1 = [ShoppingCartModel new];
    model1.shoppingCartProductID = @"200";
    model1.shoppingCartProductNumber = @"5";
    model1.shoppingCartProductSids = @"颜色:绿色;型号:cw 1224m";
    model1.shoppingCartProductPrice = @"100";
    model1.shoppingCartProductSurplusNumber = @"200";
    model1.shoppingCartProductIsDel = @"0";
    model1.shoppingCartProductTitle = @"卧室飞机发射的疙瘩发达认为企鹅发撒的发色fads认为企鹅啊发生的";
    model1.shoppingCartProductImage = @"http://g.hiphotos.baidu.com/image/pic/item/d788d43f8794a4c2b3e5d2140df41bd5ac6e39ce.jpg";
    model.shoppingCartProductBuyCert = @"0";

    
    ShoppingCartModel *model2 = [ShoppingCartModel new];
    model2.shoppingCartProductID = @"300";
    model2.shoppingCartProductNumber = @"3";
    model2.shoppingCartProductSids = @"颜色:黑色;型号:cw 1224m";
    model2.shoppingCartProductPrice = @"30";
    model2.shoppingCartProductSurplusNumber = @"200";
    model2.shoppingCartProductIsDel = @"0";
    model2.shoppingCartProductTitle = @"尽快立法家里发生的弗萨的离开分撒娇评价就哦腹地哦撒放到决赛哦";
    model2.shoppingCartProductImage = @"http://g.hiphotos.baidu.com/image/pic/item/d788d43f8794a4c2b3e5d2140df41bd5ac6e39ce.jpg";
    model.shoppingCartProductBuyCert = @"0";

    self.shoppingCardVM.shoppingCartProductsArray = [NSMutableArray new];
    [self.shoppingCardVM.shoppingCartProductsArray addObject:model];
    [self.shoppingCardVM.shoppingCartProductsArray addObject:model1];
    [self.shoppingCardVM.shoppingCartProductsArray addObject:model2];
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %d",[self.shoppingCardVM getShoppingCartProductsSelectTotalPrice]];

    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self clearNavLeftItem];
    [self initUIRelated];
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Private methods

- (void)initUIRelated {
    // NavigationBar
    [self setNavTitleString:@"购物车"];
    [self setNavRightItemWithName:@"编辑" target:self action:@selector(didClickOnEditNavButtonAction:)];
    
    // TableView
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductBriefInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kCellReuseIdentifier];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    // Buttons
    [self.payButton setNormalBackgroundColor:[UIColor themeCyanColor]
                      disableBackgroundColor:[UIColor gray005Color]];
    [self.moveToFavoriteButton setNormalBackgroundColor:[UIColor themeBlueColor]
                                 disableBackgroundColor:[UIColor gray005Color]];
    [self.removeButton setNormalBackgroundColor:[UIColor themeCyanColor]
                         disableBackgroundColor:[UIColor gray005Color]];
}

- (void)setupRefresh {
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"松开就可以刷新了";
    self.tableView.headerRefreshingText = @"正在刷新";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在加载中";
}

- (void)headerRereshing {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView footerEndRefreshing];
    });
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.totalCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    self.totalCountLabel.backgroundColor = RGB(61, 183, 235);
    self.totalCountLabel.textColor = [UIColor whiteColor];
    self.totalCountLabel.font = [UIFont systemFontOfSize:14.0];
    self.totalCountLabel.textAlignment = NSTextAlignmentCenter;
    self.totalCountLabel.text = [NSString stringWithFormat:@"共 %d 件商品",[self.shoppingCardVM getShoppingCartProductsCount]];
    
    return self.totalCountLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shoppingCardVM.shoppingCartProductsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductBriefInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    ShoppingCartModel *model = [self.shoppingCardVM.shoppingCartProductsArray objectAtIndex:indexPath.row];
    [cell setCellWithShoppingCartModel:model];
    
    if ([self.shoppingCardVM.shoppingCartProductCellEditArray containsObject:model]) {
        [cell setCellToEditType];
    } else {
        [cell setCellToNormalType];
    }
    
    if ([self.shoppingCardVM.shoppingCartProductCellSelectArray containsObject:model]) {
        [cell setCellToSelectType];
    } else {
        [cell setCellToUnSelectType];
    }

    return cell;
}


#pragma mark - TableViewCellDelegate

//点击了加按钮
- (void)didClickedOnPlusButtonWithShoppingCartModel:(ShoppingCartModel *)shoppingCartModel {
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %d",[self.shoppingCardVM getShoppingCartProductsSelectTotalPrice]];
    [self.payButton setTitle:[NSString stringWithFormat:@"结算(%d)",[self.shoppingCardVM getShoppingCartProductsSelectCount]] forState:UIControlStateNormal];
    self.totalCountLabel.text = [NSString stringWithFormat:@"共 %d 件商品",[self.shoppingCardVM getShoppingCartProductsCount]];
}

//点击了减按钮
- (void)didClickedOnReduceButtonWithShoppingCartModel:(ShoppingCartModel *)shoppingCartModel {
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %d",[self.shoppingCardVM getShoppingCartProductsSelectTotalPrice]];
    [self.payButton setTitle:[NSString stringWithFormat:@"结算(%d)",[self.shoppingCardVM getShoppingCartProductsSelectCount]] forState:UIControlStateNormal];
    self.totalCountLabel.text = [NSString stringWithFormat:@"共 %d 件商品",[self.shoppingCardVM getShoppingCartProductsCount]];
}

//点击了完成按钮
- (void)didClickedOnDoneButtonWithShoppingCartModel:(ShoppingCartModel *)shoppingCartModel {
    //发送请求
    [self.shoppingCardVM.shoppingCartProductCellEditArray removeObject:shoppingCartModel];
}

//点击了勾选按钮
- (void)didClickedOnSelectButtonWithShoppingCartModel:(ShoppingCartModel *)shoppingCartModel {
    if ([self.shoppingCardVM.shoppingCartProductCellSelectArray containsObject:shoppingCartModel]) {
        [self.shoppingCardVM.shoppingCartProductCellSelectArray removeObject:shoppingCartModel];
    } else {
        [self.shoppingCardVM.shoppingCartProductCellSelectArray addObject:shoppingCartModel];
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %d",[self.shoppingCardVM getShoppingCartProductsSelectTotalPrice]];
    [self.payButton setTitle:[NSString stringWithFormat:@"结算(%d)",[self.shoppingCardVM getShoppingCartProductsSelectCount]] forState:UIControlStateNormal];
}

//点击了删除按钮
- (void)didClickedOnDeleteButtonWithShoppingCartModel:(ShoppingCartModel *)shoppingCartModel {
    NSUInteger index = [self.shoppingCardVM.shoppingCartProductsArray indexOfObject:shoppingCartModel];
    [self.shoppingCardVM.shoppingCartProductsArray removeObject:shoppingCartModel];
    [self.shoppingCardVM.shoppingCartProductCellSelectArray removeObject:shoppingCartModel];
    [self.shoppingCardVM.shoppingCartProductCellEditArray removeObject:shoppingCartModel];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %d",[self.shoppingCardVM getShoppingCartProductsSelectTotalPrice]];
    [self.payButton setTitle:[NSString stringWithFormat:@"结算(%d)",[self.shoppingCardVM getShoppingCartProductsSelectCount]] forState:UIControlStateNormal];
    self.totalCountLabel.text = [NSString stringWithFormat:@"共 %d 件商品",[self.shoppingCardVM getShoppingCartProductsCount]];
}

//点击了编辑按钮
- (void)didClickedOnEditButtonWithShoppingCartModel:(ShoppingCartModel *)shoppingCartModel {
    [self.shoppingCardVM.shoppingCartProductCellEditArray addObject:shoppingCartModel];
}

#pragma mark - IBActions

- (void)didClickOnEditNavButtonAction:(id)sender {
//    if (self.isEditType) {
//        [self setNavRightItemWithName:@"编辑" target:self action:@selector(didClickOnEditNavButtonAction:)];
//        [self.shoppingCardVM.shoppingCartProductCellEditArray removeAllObjects];
//    } else {
//        [self setNavRightItemWithName:@"确定" target:self action:@selector(didClickOnEditNavButtonAction:)];
//        [self.shoppingCardVM.shoppingCartProductCellEditArray addObjectsFromArray:self.shoppingCardVM.shoppingCartProductsArray];
//    }
//    self.isEditType = !self.isEditType;
//    [self.tableView reloadData];
    
    FeedbackVC *vc = [[FeedbackVC alloc] init];
//    PayFailedVC *vc = [[PayFailedVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didClickSelectAllButtonAction:(id)sender {
    self.selectAllButton.selected = !self.selectAllButton.selected;
    
    if (self.selectAllButton.selected) {
        [self.shoppingCardVM.shoppingCartProductCellSelectArray addObjectsFromArray:self.shoppingCardVM.shoppingCartProductsArray];
    } else {
        [self.shoppingCardVM.shoppingCartProductCellSelectArray removeAllObjects];
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %d",[self.shoppingCardVM getShoppingCartProductsSelectTotalPrice]];
    [self.payButton setTitle:[NSString stringWithFormat:@"结算(%d)",[self.shoppingCardVM getShoppingCartProductsSelectCount]] forState:UIControlStateNormal];
    [self.tableView reloadData];
}

- (IBAction)didClickPayButtonAction:(id)sender {
    
}

- (IBAction)didClickMoveToFavoriteButtonAction:(id)sender {
    
}

- (IBAction)didClickRemoveButtonAction:(id)sender {
    
}

#pragma mark - Data Init

- (ShoppingCardVM *)shoppingCardVM {
    if (_shoppingCardVM == nil) {
        _shoppingCardVM = [ShoppingCardVM new];
    }
    return _shoppingCardVM;
}

@end
