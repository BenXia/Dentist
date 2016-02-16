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

static NSString* const kCellReuseIdentifier = @"ProductBriefInfoCell";

@interface CartVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;
@property (weak, nonatomic) IBOutlet UIView *bottomSubContentView1;
@property (weak, nonatomic) IBOutlet UIView *bottomSubContentView2;
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *moveToFavoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@end

@implementation CartVC

#pragma mark - View life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"购物车";
        self.tabBarItem.image = [UIImage imageNamed:@"btn_cart_f"];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_cart_t"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    label.backgroundColor = RGB(61, 183, 235);
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"共 %d 件商品", 3]; // TODO-Ben:
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO-Ben:
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductBriefInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - IBActions

- (void)didClickOnEditNavButtonAction:(id)sender {
    //ProductDetailVC *vc = [[ProductDetailVC alloc] init];
    OrderVC *vc = [[OrderVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didClickSelectAllButtonAction:(id)sender {
    self.selectAllButton.selected = !self.selectAllButton.selected;
}

- (IBAction)didClickPayButtonAction:(id)sender {
    
}

- (IBAction)didClickMoveToFavoriteButtonAction:(id)sender {
    
}

- (IBAction)didClickRemoveButtonAction:(id)sender {
    
}

@end
