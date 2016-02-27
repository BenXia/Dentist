//
//  HomePageVC.m
//  StudioCommon
//
//  Created by Ben on 2/2/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "HomePageVC.h"
#import "SDCycleScrollView.h"
#import "HomePageCourseListCell.h"
#import "AppDeinitializer.h"
#import "ADBannerDC.h"
#import "ADTodayIntroduceDC.h"
#import "GroupBuyingDC.h"
#import "SalesPromotionDC.h"
#import "BannerModel.h"
#import "TodayIntroduceCell.h"
#import "TuanGouCell.h"
#import "SaleActivityCell.h"
#import "ProductDetailVC.h"
#import "SearchProductVC.h"

static const CGFloat kTopImageViewRatio = 16.f/9;
static CGFloat kHomePageTopBarHeight = 64;

@interface HomePageVC () <
SDCycleScrollViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
HomePageCourseListCellDelegate,
PPDataControllerDelegate,
TodayIntroduceCellDelegate,
TuanGouCellDelegate,
saleActivityCellDelegate>

@property (weak,   nonatomic) IBOutlet UITableView* tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak,   nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (weak,   nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *searchContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarButtonTrailingConstaint;
@property (nonatomic, strong) HomePageCourseListCell *tableViewCourseListCell;   // TableView中的科目列表
@property (nonatomic, strong) HomePageCourseListCell *headerCourseListView;      // 当滑动到上面后需要常
//网络请求
@property (nonatomic, strong) ADBannerDC *adBannerRequest;
@property (nonatomic, strong) ADTodayIntroduceDC *adTodayIntroduceRequest;
@property (nonatomic, strong) GroupBuyingDC *groupBuyingRequest;
@property (nonatomic, strong) SalesPromotionDC *salesPromotionRequest;

@end

@implementation HomePageVC

#pragma mark - View life cycle

+ (void)initialize {
    kHomePageTopBarHeight = (kScreenWidth > 320) ? 64 : 54;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"首页";
        self.tabBarItem.title = @"首页";
        self.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_f"];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_t"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initUIReleated];
    
    [self downLoadfromNet];
    
    self.needHideNavBarWithAnimation = YES;
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:kNotificationActionOver object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES  animated:self.needHideNavBarWithAnimation];
    float cellHeight = (kScreenWidth - 5*24)/4 + 48;
    self.headerCourseListView.frame = CGRectMake(0, kHomePageTopBarHeight, kScreenWidth, cellHeight);
    self.tableViewCourseListCell.width = kScreenWidth;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.needHideNavBarWithAnimation = YES;
    
    //根页面禁止右滑返回
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveNotification:(NSNotification *)notification {
    if ([notification.name isEqualToString:kNotificationActionOver]) {
        self.groupBuyingRequest = [[GroupBuyingDC alloc] initWithDelegate:self];
        [self.groupBuyingRequest requestWithArgs:nil];
    }
    
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

- (void)initUIReleated {
    self.view.backgroundColor = [UIColor backGroundGrayColor];
    self.topBarHeightConstraint.constant = kHomePageTopBarHeight;
    [self initNavigationBar];
    [self initBanner];
    [self initHeaderCourseListView];
    [self initTableView];
}

- (void)initNavigationBar {
    self.searchContentView.backgroundColor = RGBA(239, 240, 241, 0.8);
    self.searchContentView.layer.cornerRadius = (kScreenWidth > 320) ? 8 : 6;
    self.searchContentView.layer.masksToBounds = YES;
}

- (void)initBanner {
    // 保证幻灯的宽高比
    CGFloat topViewHeight = kScreenWidth / kTopImageViewRatio;
    //_tableHeaderView.translatesAutoresizingMaskIntoConstraints = YES;
    //_cycleScrollView.translatesAutoresizingMaskIntoConstraints = YES;
    _tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, topViewHeight);
    _cycleScrollView.frame = CGRectMake(0, 0, kScreenWidth, topViewHeight);
    
    _cycleScrollView.infiniteLoop = YES;
    _cycleScrollView.imageURLStringsGroup = nil;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.pageControlStyle=SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.dotColor = [UIColor themeBlueColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.notSelectDotColor = [UIColor gray003Color];
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScroll = NO;
    _cycleScrollView.autoScrollTimeInterval = 10;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"网络不给力-03"];
    _cycleScrollView.needChangeHeight = YES;
}

- (void)initHeaderCourseListView {
    self.headerCourseListView = (HomePageCourseListCell *)[[[NSBundle mainBundle] loadNibNamed:@"HomePageCourseListCell" owner:nil options:nil] objectAtIndex:0];
    self.headerCourseListView.hidden = YES;
    self.headerCourseListView.delegate = self;

    self.headerCourseListView.layer.shadowOffset = CGSizeMake(0, 4);
    self.headerCourseListView.layer.shadowOpacity = 0.2;
    self.headerCourseListView.layer.shadowRadius = 1;
    self.headerCourseListView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [self.view addSubview:self.headerCourseListView];
}

- (void)initTableView {
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableViewCourseListCell = (HomePageCourseListCell *)[[[NSBundle mainBundle] loadNibNamed:@"HomePageCourseListCell" owner:nil options:nil] objectAtIndex:0];
    self.tableViewCourseListCell.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TodayIntroduceCell" bundle:nil] forCellReuseIdentifier:[TodayIntroduceCell identifier]];
    [self.tableView registerNib:[UINib nibWithNibName:@"TuanGouCell" bundle:nil] forCellReuseIdentifier:[TuanGouCell identifier]];
    [self.tableView registerNib:[UINib nibWithNibName:@"SaleActivityCell" bundle:nil] forCellReuseIdentifier:[SaleActivityCell identifier]];
}


- (void)refreshBanner {
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    for (BannerModel* banner in self.adBannerRequest.bannerArr) {
        NSString* imageUrl = banner.imgUrl;
        if (imagesURLStrings.count<10) {
            [imagesURLStrings addObject:imageUrl];
        }
    }
    
    if (imagesURLStrings.count > 1) {
        _cycleScrollView.autoScroll=YES;
    } else {
        _cycleScrollView.autoScroll=NO;
        
    }
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    _cycleScrollView.hidden=NO;
}

- (void)refreshHeaderCourseListView {
    CGPoint point = self.tableView.contentOffset;
    CGFloat originHeaderHeight = self.tableHeaderView.height;
    
    if (point.y >= originHeaderHeight) {
        self.headerCourseListView.hidden = NO;
    } else {
        self.headerCourseListView.hidden = YES;
    }

}

#pragma mark - NetWork

- (void)downLoadfromNet {
    self.adBannerRequest = [[ADBannerDC alloc] initWithDelegate:self];
    [self.adBannerRequest requestWithArgs:nil];
    
    self.adTodayIntroduceRequest = [[ADTodayIntroduceDC alloc] initWithDelegate:self];
    [self.adTodayIntroduceRequest requestWithArgs:nil];
    
    self.salesPromotionRequest = [[SalesPromotionDC alloc] initWithDelegate:self];
    [self.salesPromotionRequest requestWithArgs:nil];
    
    self.groupBuyingRequest = [[GroupBuyingDC alloc] initWithDelegate:self];
    [self.groupBuyingRequest requestWithArgs:nil];
    
    
}

#pragma mark - IBActions


- (IBAction)didTapSearchButton:(id)sender {
    SearchProductVC* searchVC = [SearchProductVC new];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    BannerModel *model = self.adBannerRequest.bannerArr[index];
    ProductDetailVC *detailVC = [[ProductDetailVC alloc] initWithProductId:model.iid];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 控制TableHeaderView
    CGPoint point = scrollView.contentOffset;
    if (point.y < 0) {
        CGFloat cycleScrollViewHeight = kScreenWidth / kTopImageViewRatio - point.y;
        CGFloat cycleScrollViewWidth = cycleScrollViewHeight * kTopImageViewRatio;
        CGFloat cycleScrollViewOriginX = (kScreenWidth - cycleScrollViewWidth) / 2;
        CGFloat cycleScrollViewOriginY = point.y;
        _cycleScrollView.frame = CGRectMake(cycleScrollViewOriginX, cycleScrollViewOriginY, cycleScrollViewWidth, cycleScrollViewHeight);
        
        [_cycleScrollView stopAutoScrollTimer];
    } else {
        
        CGFloat cycleScrollViewHeight = kScreenWidth / kTopImageViewRatio;
        _cycleScrollView.frame = CGRectMake(0, 0, kScreenWidth, cycleScrollViewHeight);
        
        [_cycleScrollView startAutoScrollTimerIfNeeded];
    }
    
    [self refreshHeaderCourseListView];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.tableViewCourseListCell;
    } else if (indexPath.section == 1) {
        TodayIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:[TodayIntroduceCell identifier] forIndexPath:indexPath];
        cell.cellModel = self.adTodayIntroduceRequest.productArray;
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 2) {
        TuanGouCell *cell = [tableView dequeueReusableCellWithIdentifier:[TuanGouCell identifier] forIndexPath:indexPath];
        cell.cellModelArray = self.groupBuyingRequest.productArray;
        cell.endTime = self.groupBuyingRequest.end_time;
        cell.delegate = self;
        return cell;
    }  else if (indexPath.section == 3) {
        SaleActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:[SaleActivityCell identifier] forIndexPath:indexPath];
        cell.delegate = self;
        cell.cellModelArray = self.salesPromotionRequest.productArray;
        return cell;
    } else {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.backgroundColor = [UIColor themeBlueColor];
        }
        //[cell refreshUIWithTeacherList:self.homePageVM.promotedTeacherArray];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        float cellHeight = (kScreenWidth - 5*24)/4 + 48;
        return cellHeight;
    } else if (indexPath.section == 1) {
        return 200;
    } else if (indexPath.section == 2) {
        return 320;
    } else if (indexPath.section == 3) {
        return 400;
    } else {
        return 300;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 12;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

#pragma mark - HomePageCourseListCellDelegate

- (void)didSelectCourseWithId:(int)courseId {
    // （重要）设置下订单方式：首页老师列表（包括科目横向列表）
    
}

#pragma mark - CellDelegate

- (void)todayIntroduceCell:(TodayIntroduceCell *)cell toProductDetailWith:(NSString *)iid {
    //ProductDetailVC *detailVC = [[ProductDetailVC alloc] initWithProductId:@"143"];
    ProductDetailVC *detailVC = [[ProductDetailVC alloc] initWithProductId:iid];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tuanGouCell:(TuanGouCell *)cell toProductDetailWith:(NSString *)iid {
    ProductDetailVC *detailVC = [[ProductDetailVC alloc] initWithProductId:iid];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)saleActivityCell:(SaleActivityCell *)cell toProductDetailWith:(NSString *)iid {
    ProductDetailVC *detailVC = [[ProductDetailVC alloc] initWithProductId:iid];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - PPDataControllerDelegate

- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error {
    [[GCDQueue mainQueue] queueBlock:^{
        self.view.userInteractionEnabled = NO;
        if (controller == self.adBannerRequest) {
            [Utilities showToastWithText:[NSString stringWithFormat:@"获取Banner位失败"]];
        } else if (controller == self.adTodayIntroduceRequest){
            [Utilities showToastWithText:[NSString stringWithFormat:@"获取每日推荐失败"]];
        } else if (controller == self.groupBuyingRequest){
            [Utilities showToastWithText:[NSString stringWithFormat:@"获取团购失败"]];
        } else if (controller == self.salesPromotionRequest){
            [Utilities showToastWithText:[NSString stringWithFormat:@"获取促销失败"]];
        }
    
    }];
}

- (void)loadingDataFinished:(PPDataController *)controller {
    self.view.userInteractionEnabled = YES;
    if (controller == self.adBannerRequest) {
        [self refreshBanner];
        
    } else if (controller == self.adTodayIntroduceRequest) {
        [self.tableView reloadData];
    } else if (controller == self.groupBuyingRequest){
        [self.tableView reloadData];
        
    } else if (controller == self.salesPromotionRequest){
        
        [self.tableView reloadData];
    }
}


@end