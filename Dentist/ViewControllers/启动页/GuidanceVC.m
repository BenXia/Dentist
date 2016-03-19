//
//  GuidanceVC.m
//  QQing
//
//  Created by xiaofengxie on 15/7/2.
//
//

#import "GuidanceVC.h"
#import "SDCycleScrollView.h"

#define kGapXOfStartButton  60

@interface GuidanceVC () <UIScrollViewDelegate>

@property (nonatomic, weak)   IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl* pageControl;

@property (nonatomic, strong) NSArray *scrollViewImages;
@property (nonatomic, strong) Block completeBlock;

@property (nonatomic, assign) BOOL isFirstEnter;

@end

@implementation GuidanceVC

- (instancetype)initWithCompleteBlock:(Block)block {
    if (self = [super init]) {
        self.completeBlock = block;
        self.isFirstEnter = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if (self.isFirstEnter) {
        self.isFirstEnter = NO;
        
        [self initUI];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    if (IS_SCREEN_35_INCH) {
        _scrollViewImages = @[
                              [UIImage imageNamed:@"guide1_35_inch"],
                              [UIImage imageNamed:@"guide2_35_inch"],
                              [UIImage imageNamed:@"guide3_35_inch"],
                              [UIImage imageNamed:@"guide4_35_inch"],
                              [UIImage imageNamed:@"guide5_35_inch"]
                              ];
    } else if(IS_SCREEN_4_INCH){
        _scrollViewImages = @[
                              [UIImage imageNamed:@"guide1_4_inch"],
                              [UIImage imageNamed:@"guide2_4_inch"],
                              [UIImage imageNamed:@"guide3_4_inch"],
                              [UIImage imageNamed:@"guide4_4_inch"],
                              [UIImage imageNamed:@"guide5_4_inch"]
                              ];
    } else if(IS_SCREEN_47_INCH){
        _scrollViewImages = @[
                              [UIImage imageNamed:@"guide1_47_inch"],
                              [UIImage imageNamed:@"guide2_47_inch"],
                              [UIImage imageNamed:@"guide3_47_inch"],
                              [UIImage imageNamed:@"guide4_47_inch"],
                              [UIImage imageNamed:@"guide5_47_inch"]
                              ];
    } else if(IS_SCREEN_55_INCH){
        _scrollViewImages = @[
                              [UIImage imageNamed:@"guide1_55_inch"],
                              [UIImage imageNamed:@"guide2_55_inch"],
                              [UIImage imageNamed:@"guide3_55_inch"],
                              [UIImage imageNamed:@"guide4_55_inch"],
                              [UIImage imageNamed:@"guide5_55_inch"]
                              ];
    }

    UIImageView* lastImageView = nil;
    self.scrollView.backgroundColor = [g_commonConfig themeBackGrayColor];
    for (int i = 0; i < _scrollViewImages.count; ++i) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        imageView.userInteractionEnabled = YES;
        imageView.image = [_scrollViewImages objectAtIndex:i];
        [self.scrollView addSubview:imageView];
        lastImageView = imageView;
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*_scrollViewImages.count, kScreenHeight);
    
    UIButton* startButton = [[UIButton alloc] initWithFrame:CGRectMake(kGapXOfStartButton, kScreenHeight-100, kScreenWidth-2*kGapXOfStartButton, 44)];
    [startButton setTitle:@"立即体验" forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [startButton colorlumpThematized:[g_commonConfig themeCyanColor]];
    [startButton addTarget:self action:@selector(didClickStartButton) forControlEvents:UIControlEventTouchUpInside];
    [lastImageView addSubview:startButton];
    
    UIPageControl* pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight - 20, kScreenWidth, 10)];
    pageControl.numberOfPages = _scrollViewImages.count;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [[g_commonConfig gray003Color] colorWithAlphaComponent:0.8];
    pageControl.currentPageIndicatorTintColor = [g_commonConfig themeBlueColor];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

#pragma mark - UI Action

- (void)didClickStartButton {
    [[NSUserDefaults standardUserDefaults] setObject:[AppSystem appVersion] forKey:kLastShownGuidanceVCAppVersion];
    if (self.completeBlock) {
        self.completeBlock();
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    int currentPage = offset.x / kScreenWidth;
    if (currentPage != self.pageControl.currentPage) {
        self.pageControl.currentPage = currentPage;
        [self.pageControl updateCurrentPageDisplay];
    }
}

@end

