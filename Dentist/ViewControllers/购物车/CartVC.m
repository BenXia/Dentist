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

@interface CartVC () <UITableViewDataSource, UITableViewDelegate,ProductBriefInfoCellDelegate,PPDataControllerDelegate>

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
    [self initUIRelated];
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView headerBeginRefreshing];
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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self clearNavLeftItem];
}

/*
 *获取购物车列表
 */
- (void)sendCartListRequest {
    self.shoppingCardVM.cartListDC = [[CartListDC alloc] initWithDelegate:self];
    [self.shoppingCardVM.cartListDC requestWithArgs:nil];
}

/*
 *删除购物车商品
 */
- (void)sendCartProductDeleteRequest:(ShoppingCartModel *)shoppingCartModel {
    self.shoppingCardVM.cartProductDeleteDC = [[CartProductDeleteDC alloc] initWithDelegate:self];
    self.shoppingCardVM.cartProductDeleteDC.productIdArray = [NSMutableArray arrayWithObject:shoppingCartModel.shoppingCartProductID];
    [self.shoppingCardVM.cartProductDeleteDC requestWithArgs:nil];
}

/*
 *批量删除购物车商品
 */
- (void)sendCartProductDeleteRequest {
    self.shoppingCardVM.cartProductDeleteDC = [[CartProductDeleteDC alloc] initWithDelegate:self];
    self.shoppingCardVM.cartProductDeleteDC.productIdArray = [self.shoppingCardVM getProductSelectIDArray];
    [self.shoppingCardVM.cartProductDeleteDC requestWithArgs:nil];
}

/*
 *批量添加到收藏夹
 */
- (void)sendAddFavoriteRequest {
    self.shoppingCardVM.addFavoriteDC = [[AddFavoriteDC alloc] initWithDelegate:self];
    self.shoppingCardVM.addFavoriteDC.productIds = [self.shoppingCardVM getProductSelectIDArray];
    
    [self.shoppingCardVM.addFavoriteDC requestWithArgs:nil];
}

/*
 *批量更新购物车商品数量
 */
- (void)sendCartProductUpdateNumberRequest {
    self.shoppingCardVM.cartProductUpdateNumberDC = [[CartProductUpdateNumberDC alloc] initWithDelegate:self];
    self.shoppingCardVM.cartProductUpdateNumberDC.cartProductIdArray = [self.shoppingCardVM getAllProductIDArray];
    self.shoppingCardVM.cartProductUpdateNumberDC.productNumberArray = [self.shoppingCardVM getAllProductNumberArray];
    [self.shoppingCardVM.cartProductUpdateNumberDC requestWithArgs:nil];
}

/*
 *更新购物车商品数量
 */
- (void)sendCartProductUpdateNumberRequest:(ShoppingCartModel *)shoppingCartModel {
    self.shoppingCardVM.cartProductUpdateNumberDC = [[CartProductUpdateNumberDC alloc] initWithDelegate:self];
    self.shoppingCardVM.cartProductUpdateNumberDC.cartProductIdArray = [NSMutableArray arrayWithObject:shoppingCartModel.shoppingCartProductID];
    self.shoppingCardVM.cartProductUpdateNumberDC.productNumberArray = [NSMutableArray arrayWithObject:shoppingCartModel.shoppingCartProductNumber];
    [self.shoppingCardVM.cartProductUpdateNumberDC requestWithArgs:nil];
}

- (void)setupRefresh {
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"松开就可以刷新了";
    self.tableView.headerRefreshingText = @"正在刷新";
}

- (void)headerRereshing {
    [self sendCartListRequest];
}

#pragma mark - PPDataControllerDelegate

//数据请求成功回调
- (void)loadingDataFinished:(PPDataController *)controller{
    if ([controller isKindOfClass:[CartListDC class]]) {
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %d",[self.shoppingCardVM getShoppingCartProductsSelectTotalPrice]];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } else if ([controller isKindOfClass:[CartProductDeleteDC class]]) {
        for (ShoppingCartModel *shoppingCartModel in self.shoppingCardVM.shoppingCartProductCellDeleteArray) {
            [self.shoppingCardVM.cartListDC.shoppingCartProductsArray removeObject:shoppingCartModel];
            [self.shoppingCardVM.shoppingCartProductCellSelectArray removeObject:shoppingCartModel];
            [self.shoppingCardVM.shoppingCartProductCellEditArray removeObject:shoppingCartModel];
        }
        [self.tableView reloadData];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %d",[self.shoppingCardVM getShoppingCartProductsSelectTotalPrice]];
        [self.payButton setTitle:[NSString stringWithFormat:@"结算(%d)",[self.shoppingCardVM getShoppingCartProductsSelectCount]] forState:UIControlStateNormal];
        self.totalCountLabel.text = [NSString stringWithFormat:@"共 %d 件商品",[self.shoppingCardVM getShoppingCartProductsCount]];
    } else if ([controller isKindOfClass:[AddFavoriteDC class]]) {
        [Utilities showToastWithText:@"移到收藏夹成功"];
    } else if ([controller isKindOfClass:[CartProductUpdateNumberDC class]]) {
        
    }
}

//数据请求失败回调
- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error{
    if ([controller isKindOfClass:[CartListDC class]]) {
        [Utilities showToastWithText:@"购物车列表获取失败"];
        [self.tableView headerEndRefreshing];
    } else if ([controller isKindOfClass:[CartProductDeleteDC class]]) {
        [Utilities showToastWithText:@"商品删除失败"];
    } else if ([controller isKindOfClass:[AddFavoriteDC class]]) {
        [Utilities showToastWithText:@"商品移到收藏夹失败"];
    } else if ([controller isKindOfClass:[CartProductUpdateNumberDC class]]) {
        [Utilities showToastWithText:@"商品更新数量失败"];
    }
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
    return self.shoppingCardVM.cartListDC.shoppingCartProductsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductBriefInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    ShoppingCartModel *model = [self.shoppingCardVM.cartListDC.shoppingCartProductsArray objectAtIndex:indexPath.row];
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

    if (self.isEditType) {
        [cell hideDeleteAndFinishButton];
    } else {
        [cell showDeleteAndFinishButton];
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
    [self sendCartProductUpdateNumberRequest:shoppingCartModel];
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
    [self.shoppingCardVM.shoppingCartProductCellDeleteArray addObject:shoppingCartModel];
    [self sendCartProductDeleteRequest:shoppingCartModel];
}

//点击了编辑按钮
- (void)didClickedOnEditButtonWithShoppingCartModel:(ShoppingCartModel *)shoppingCartModel {
    [self.shoppingCardVM.shoppingCartProductCellEditArray addObject:shoppingCartModel];
}

#pragma mark - IBActions

- (void)didClickOnEditNavButtonAction:(id)sender {
    if (self.isEditType) {
        [self setNavRightItemWithName:@"编辑" target:self action:@selector(didClickOnEditNavButtonAction:)];
        [self.shoppingCardVM.shoppingCartProductCellEditArray removeAllObjects];
        self.bottomSubContentView1.hidden = NO;
        self.bottomSubContentView2.hidden = YES;
        [self sendCartProductUpdateNumberRequest];
    } else {
        [self setNavRightItemWithName:@"确定" target:self action:@selector(didClickOnEditNavButtonAction:)];
        [self.shoppingCardVM.shoppingCartProductCellEditArray addObjectsFromArray:self.shoppingCardVM.cartListDC.shoppingCartProductsArray];
        self.bottomSubContentView1.hidden = YES;
        self.bottomSubContentView2.hidden = NO;
    }
    self.isEditType = !self.isEditType;
    [self.tableView reloadData];
    
//    OrderVC *vc = [[OrderVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didClickSelectAllButtonAction:(id)sender {
    self.selectAllButton.selected = !self.selectAllButton.selected;
    
    if (self.selectAllButton.selected) {
        [self.shoppingCardVM.shoppingCartProductCellSelectArray addObjectsFromArray:self.shoppingCardVM.cartListDC.shoppingCartProductsArray];
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
    [self sendAddFavoriteRequest];
}

- (IBAction)didClickRemoveButtonAction:(id)sender {
    self.shoppingCardVM.shoppingCartProductCellDeleteArray = self.shoppingCardVM.shoppingCartProductCellSelectArray;
    [self sendCartProductDeleteRequest];
}

#pragma mark - Data Init

- (ShoppingCardVM *)shoppingCardVM {
    if (_shoppingCardVM == nil) {
        _shoppingCardVM = [ShoppingCardVM new];
    }
    return _shoppingCardVM;
}

@end
