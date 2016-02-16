//
//  ProductDetailVC.m
//  Dentist
//
//  Created by Ben on 16/2/14.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "ProductDetailVC.h"
#import "ProductDetailVM.h"
#import "SDCycleScrollView.h"
#import "ProductBaseInfoCell.h"
#import "ProductComboCell.h"
#import "ProductGiftCell.h"
#import "ProductCustomiseCell.h"
#import "ProductFeedbackTitleCell.h"
#import "ProductFeedbackItemCell.h"
#import "ProductGuessULikeCell.h"
#import "ProductSeeMoreCell.h"
#import "ProductImageTextCell.h"

static const CGFloat kProductDetailVCTopImageRatio = 16.f/9;

@interface ProductDetailVC () <
UITableViewDataSource,
UITableViewDelegate,
SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak,   nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) ProductDetailVM *vm;

@property (weak, nonatomic) IBOutlet UIView *popupCustomiseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popupCustomiseViewHeightConstraint;

@end

@implementation ProductDetailVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUIReleated];
    
    [self bindViewModel];
}

- (void)viewDidAppear:(BOOL)animated {
    // TODO-Ben:删除测试代码
    [self refreshBanner];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private methods

- (ProductDetailVM *)vm {
    if (!_vm) {
        _vm = [[ProductDetailVM alloc] init];
    }
    
    return _vm;
}

- (void)initUIReleated {
    [self.navigationController setNavigationBarHidden:YES];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initBanner];
    [self initTableView];
    [self initPopupCustomiseView];
}

- (void)initBanner {
    // 保证幻灯的宽高比
    CGFloat topViewHeight = kScreenWidth / kProductDetailVCTopImageRatio;
    _tableHeaderView.translatesAutoresizingMaskIntoConstraints = YES;
    _cycleScrollView.translatesAutoresizingMaskIntoConstraints = YES;
    _tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, topViewHeight);
    _cycleScrollView.frame = CGRectMake(0, 0, kScreenWidth, topViewHeight);
    
    _cycleScrollView.infiniteLoop = YES;
    _cycleScrollView.imageURLStringsGroup = nil;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.pageControlStyle=SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScroll = NO;
    _cycleScrollView.autoScrollTimeInterval = 10;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"ic_top_blank.png"];
    _cycleScrollView.needChangeHeight = YES;
}

- (void)initTableView {
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
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductBaseInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ProductBaseInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductComboCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ProductComboCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductGiftCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ProductGiftCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductCustomiseCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ProductCustomiseCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductFeedbackTitleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ProductFeedbackTitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductFeedbackItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ProductFeedbackItemCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductGuessULikeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ProductGuessULikeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductComboCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ProductComboCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductSeeMoreCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ProductSeeMoreCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductImageTextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ProductImageTextCell"];
}

- (void)initPopupCustomiseView {    
    self.popupCustomiseView.layer.shadowOffset = CGSizeMake(2, -2);
    self.popupCustomiseView.layer.shadowOpacity = 0.1;
    self.popupCustomiseView.layer.shadowRadius = 1;
    self.popupCustomiseView.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)bindViewModel {
//    @weakify(self);
//    
//    // 对智康家长隐藏科目入口
//    [[[RACObserve([StudentInfoModel sharedInstance], isFromZhiKang) distinctUntilChanged] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNumber* x) {
//        @strongify(self);
//        [self.tableView reloadData];
//        [self refreshHeaderCourseListView];
//        
//        if ([StudentInfoModel sharedInstance].isLoggedin && [StudentInfoModel sharedInstance].isFromZhiKang) {
//            self.tableView.contentOffset = CGPointZero;
//            self.tableView.scrollEnabled = NO;
//        } else {
//            self.tableView.scrollEnabled = YES;
//        }
//    }];
//    
//    // 监听登录状态(对智康家长隐藏科目入口)
//    [[[RACObserve([StudentInfoModel sharedInstance], isLoggedin) distinctUntilChanged] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
//        @strongify(self);
//        [self.tableView reloadData];
//        [self refreshHeaderCourseListView];
//        
//        if ([StudentInfoModel sharedInstance].isLoggedin && [StudentInfoModel sharedInstance].isFromZhiKang) {
//            self.tableView.contentOffset = CGPointZero;
//            self.tableView.scrollEnabled = NO;
//        } else {
//            self.tableView.scrollEnabled = YES;
//        }
//    }];
//    
//    // 刷新城市信息
//    [[RACObserve([StudentInfoModel sharedInstance], cityId) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNumber* cityId) {
//        @strongify(self);
//        if (cityId) {
//            self.selectedCity = [[CityCache sharedCityCache] objectForId:cityId];
//            self.cityNameLabel.text = self.selectedCity.cityName;
//            
//            [self.bannerVM.cmd_getHomePageBanners execute:cityId];
//            
//            [self.homePageVM.cmd_getPromotedTeacherArray execute:cityId];
//        }
//    }];
//    
//    // 未登录成功时，使用定位城市
//    if (![StudentInfoModel sharedInstance].isLoggedin) {
//        [[LocationService sharedInstance] currentLocationWithBlock:^(LocationModel *location) {
//            //用户手动选择了城市后，不再使用定位信息
//            if ([StudentInfoModel sharedInstance].cityId) {
//                return ;
//            }
//            //定位失败会强制选择城市
//            NSString *cityName=[[UserCityService sharedUserCityService] getUserCityName];
//            if (cityName) {
//                [StudentInfoModel sharedInstance].cityId = [[CityCache sharedCityCache] idForname:cityName];
//            } else if (location) {
//                [StudentInfoModel sharedInstance].cityId =  @(location.cityID);
//                [StudentInfoModel saveCityIdToCache:@(location.cityID)];
//            } else {
//                [self didClickSelectCity];
//            }
//        }];
//    }
//    
//    // Banner广告
//    RACCommand* cmd_getHomePageBanners = self.bannerVM.cmd_getHomePageBanners;
//    [cmd_getHomePageBanners.executionSignals subscribeNext:^(RACSignal* x) {
//        [[x deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
//            @strongify(self);
//            [self refreshBanner];
//        }];
//    }];
//    
//    // 名师风采列表
//    [self.homePageVM.cmd_getPromotedTeacherArray.executionSignals subscribeNext:^(RACSignal* x) {
//        [[x deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
//            @strongify(self);
//            [self.tableView reloadData];
//        }];
//    }];
}

- (void)refreshBanner {
//    CGFloat topViewWidth = kScreenWidth;
//    CGFloat topViewHeight = topViewWidth / kProductDetailVCTopImageRatio;
//    NSArray* bannersArray = self.bannerVM.bannerWithPageItems;
//    NSMutableArray *imagesURLStrings = [NSMutableArray arrayWithCapacity:bannersArray.count];
//    for (GPBBannerItemWithPage* banner in bannersArray) {
//        // 4.8.0中要求最多显示8张banner位
//        if (imagesURLStrings.count < 8) {
//            NSString* imageUrl = [ImageUtil urlForDownloadImageWithPath:banner.imagePath Operation:kImageOperationResize Size:CGSizeMake(topViewWidth, topViewHeight)];
//            [imagesURLStrings addObject:imageUrl];
//        } else {
//            break;
//        }
//    }
    
    NSMutableArray *imagesURLStrings = [NSMutableArray arrayWithObjects:
                                        @"http://www.hkstv.hk:8080/adver/picture/2014/5/0c64828b-8e37-4d11-8a58-880382981731.jpg",
                                        @"http://www.bz55.com/uploads/allimg/150309/139-150309101A0.jpg",
                                        @"http://www.bz55.com/uploads/allimg/150309/139-150309101F2.jpg",
                                        @"http://www.bz55.com/uploads/allimg/150309/139-150309101F7.jpg",
                                        @"http://pic38.nipic.com/20140215/12359647_224250202132_2.jpg", nil];
    
    if (imagesURLStrings.count > 1) {
        _cycleScrollView.autoScroll=YES;
    } else {
        _cycleScrollView.autoScroll=NO;
        
    }
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    _cycleScrollView.hidden=NO;
}

#pragma mark - 上下拉刷新

- (void)headerRereshing {
//    if ([StudentInfoModel sharedInstance].isLoggedin) {
//        [self.vm.getStudyTrackArrayCommand execute:nil];
//    }
}

- (void)footerRereshing {
//    if ([StudentInfoModel sharedInstance].isLoggedin) {
//        if (!self.vm.hasNextPage) {
//            [self.tableView footerEndRefreshing];
//            [Utils showToastWithText:@"无更多数据")];
//            return;
//        }
//        [self.vm.getMoreStudyTrackArrayCommand execute:nil];
//    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductBaseInfoCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    GPBStudyTraceDetail *studyTrace = self.vm.studyTrackArray[indexPath.row];
//    cell.delegate = self;
//    [cell setupWithStudyTraceDetailModel:studyTrace];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    GPBStudyTraceDetail *studyTrace = self.vm.studyTrackArray[indexPath.row];
//    return [StudyTrackCell cellHeightWithStudyTraceDetailModel:studyTrace];
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    GPBBannerItemWithPage* banner = [self.bannerVM.bannerWithPageItems objectAtIndexIfIndexInBounds:index];
//    BaseWebViewController *baseWebVC = [[BaseWebViewController alloc] initWithUrl:banner.pagePath];
//    baseWebVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:baseWebVC animated:YES];
}

@end
