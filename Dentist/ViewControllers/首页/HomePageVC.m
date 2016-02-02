//
//  HomePageVC.m
//  StudioCommon
//
//  Created by Ben on 2/2/16.
//
//

#import "HomePageVC.h"
#import "SDCycleScrollView.h"
#import "HomePageCourseListCell.h"
#import "AppDeinitializer.h"
#import "ADBannerDC.h"
#import "BannerModel.h"

static const CGFloat kTopImageViewRatio = 16.f/9;
static CGFloat kHomePageTopBarHeight = 64;

@interface HomePageVC () <
SDCycleScrollViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
HomePageCourseListCellDelegate,
PPDataControllerDelegate>

@property (weak,   nonatomic) IBOutlet UITableView* tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak,   nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (weak,   nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *searchContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarButtonTrailingConstaint;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, strong) HomePageCourseListCell *tableViewCourseListCell;   // TableView中的科目列表
@property (nonatomic, strong) HomePageCourseListCell *headerCourseListView;      // 当滑动到上面后需要常
//网络请求
@property (nonatomic, strong) ADBannerDC *adBannerRequest;


@end

@implementation HomePageVC

#pragma mark - View life cycle

+ (void)initialize {
    kHomePageTopBarHeight = (kScreenWidth > 320) ? 64 : 54;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES  animated:self.needHideNavBarWithAnimation];
    
    self.headerCourseListView.frame = CGRectMake(0, kHomePageTopBarHeight, kScreenWidth, 80);
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
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

- (void)initHeaderCourseListView {
    self.headerCourseListView = (HomePageCourseListCell *)[[[NSBundle mainBundle] loadNibNamed:@"HomePageCourseListCell" owner:nil options:nil] objectAtIndex:0];
    self.headerCourseListView.hidden = YES;
    self.headerCourseListView.delegate = self;
    [self.headerCourseListView reloadData];
    self.headerCourseListView.scrollView.backgroundColor = [UIColor whiteColor];
    self.headerCourseListView.scrollContentView.backgroundColor = [UIColor whiteColor];

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
    [self.tableViewCourseListCell reloadData];
}


- (void)refreshBanner {
//    CGFloat topViewWidth = kScreenWidth;
//    CGFloat topViewHeight = topViewWidth / kTopImageViewRatio;
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    for (BannerModel* banner in self.adBannerRequest.bannerArr) {
        NSString* imageUrl = banner.imaUrl;
        [imagesURLStrings addObject:imageUrl];
    }
    
    if (imagesURLStrings.count > 1) {
        _cycleScrollView.autoScroll=YES;
    } else {
        _cycleScrollView.autoScroll=NO;
        
    }
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"pic_index_qq01"];
    _cycleScrollView.hidden=NO;
}

- (void)refreshHeaderCourseListView {
    CGPoint point = self.tableView.contentOffset;
    CGFloat originHeaderHeight = self.tableHeaderView.height;
    
    if (point.y >= (originHeaderHeight - kHomePageTopBarHeight)) {
        self.headerCourseListView.hidden = NO;
    } else {
        self.headerCourseListView.hidden = YES;
    }

}

#pragma mark - NetWork

- (void)downLoadfromNet {
    self.adBannerRequest = [[ADBannerDC alloc] init];
    self.adBannerRequest.delegate = self;
    [self.adBannerRequest requestWithArgs:nil];
}

#pragma mark - IBActions

- (IBAction)didTouchDownSelectCityButton:(id)sender {
    self.cityNameLabel.alpha = 0.5;
    self.arrowImageView.alpha = 0.5;
}

- (IBAction)didTouchUpInsideSelectCityButton:(id)sender {
    self.cityNameLabel.alpha = 1.0;
    self.arrowImageView.alpha = 1.0;
    //测试退出功能
    [[AppDeinitializer sharedInstance] cleanUpWhenLogout];
}

- (IBAction)didTouchUpOutsideSelectCityButton:(id)sender {
    self.cityNameLabel.alpha = 1.0;
    self.arrowImageView.alpha = 1.0;
}

- (IBAction)didTouchDragInsideSelectCityButton:(id)sender {
    self.cityNameLabel.alpha = 0.5;
    self.arrowImageView.alpha = 0.5;
}

- (IBAction)didTouchDragOutsideSelectCityButton:(id)sender {
    self.cityNameLabel.alpha = 1.0;
    self.arrowImageView.alpha = 1.0;
}

- (IBAction)didTapPhoneNumberSearchTeacherAction:(id)sender {
      
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    //
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 控制TableHeaderView
    CGPoint point = scrollView.contentOffset;
    CGFloat originHeaderHeight = self.tableHeaderView.height;
    if (point.y < 0) {
        self.statusBarStyle = UIStatusBarStyleLightContent;
        
        CGFloat cycleScrollViewHeight = kScreenWidth / kTopImageViewRatio - point.y;
        CGFloat cycleScrollViewWidth = cycleScrollViewHeight * kTopImageViewRatio;
        CGFloat cycleScrollViewOriginX = (kScreenWidth - cycleScrollViewWidth) / 2;
        CGFloat cycleScrollViewOriginY = point.y;
        _cycleScrollView.frame = CGRectMake(cycleScrollViewOriginX, cycleScrollViewOriginY, cycleScrollViewWidth, cycleScrollViewHeight);
        
        [_cycleScrollView stopAutoScrollTimer];
    } else {
        
        if (point.y > (originHeaderHeight - kHomePageTopBarHeight - 30)) {
            //self.cityNameLabel.textColor = kWhiteHighlightedColor;
            self.arrowImageView.image = [UIImage imageNamed:@"pic_place01_white_highlighted"];
            self.statusBarStyle = UIStatusBarStyleDefault;
        } else {
            self.cityNameLabel.textColor = [UIColor whiteColor];
            self.arrowImageView.image = [UIImage imageNamed:@"pic_place01_white"];
            self.statusBarStyle = UIStatusBarStyleLightContent;
        }
        
        CGFloat cycleScrollViewHeight = kScreenWidth / kTopImageViewRatio;
        _cycleScrollView.frame = CGRectMake(0, 0, kScreenWidth, cycleScrollViewHeight);
        
        [_cycleScrollView startAutoScrollTimerIfNeeded];
    }
    
    [self refreshHeaderCourseListView];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.tableViewCourseListCell;
    } else {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        //[cell refreshUIWithTeacherList:self.homePageVM.promotedTeacherArray];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - HomePageCourseListCellDelegate

- (void)didSelectCourseWithId:(int)courseId {
    // （重要）设置下订单方式：首页老师列表（包括科目横向列表）
    
}

- (void)didCourseListCell:(HomePageCourseListCell *)cell scrollToOffset:(CGPoint)offset {
    if (!self.headerCourseListView.hidden) {
        if (cell == self.headerCourseListView) {
            self.tableViewCourseListCell.scrollView.contentOffset = offset;
        }
    } else {
        if (cell == self.tableViewCourseListCell) {
            self.headerCourseListView.scrollView.contentOffset = offset;
        }
    }
}

#pragma mark - PPDataControllerDelegate

- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error {
    [[GCDQueue mainQueue] queueBlock:^{
        if (controller == self.adBannerRequest) {
            [Utilities showToastWithText:[NSString stringWithFormat:@"获取Banner位失败:%@", error]];
        } else {
            [Utilities showToastWithText:[NSString stringWithFormat:@"验证码获取失败:%@", error]];
        }    }];
}

- (void)loadingDataFinished:(PPDataController *)controller {
    if (controller == self.adBannerRequest) {
        [self refreshBanner];
        
    } else {
        
    }
}


@end