//
//  GuidanceVC.m
//  QQing
//
//  Created by xiaofengxie on 15/7/2.
//
//

#import "GuidanceVC.h"
#import "SDCycleScrollView.h"

@interface GuidanceVC () <UIScrollViewDelegate,UIGestureRecognizerDelegate,SDCycleScrollViewDelegate>

@property (nonatomic,strong) NSArray *scrollViewImages;
@property (nonatomic,strong) Block completeBlock;
@property (nonatomic,weak) IBOutlet UIButton* startButton;

@end

@implementation GuidanceVC


-(instancetype)initWithCompleteBlock:(Block)block{
    if (self = [super init]) {
        self.completeBlock = block;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view from its nib.
    
    //加载图片
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
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
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) infiniteLoop:NO imagesGroup:_scrollViewImages];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.pageControlStyle=SDCycleScrollViewPageContolStyleClassic;
    cycleScrollView.dotColor = [UIColor themeBlueColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.notSelectDotColor = [[UIColor gray003Color] colorWithAlphaComponent:0.8];
    cycleScrollView.autoScroll = NO;
    cycleScrollView.delegate = self;
    cycleScrollView.backgroundColor = [UIColor themeBackGrayColor];
    [self.view addSubview:cycleScrollView];
    
    [self.startButton colorlumpThematized:[UIColor themeCyanColor]];
    self.startButton.hidden = YES;
    [self.startButton bringToFront];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView scrollToIndex:(NSInteger)index{
    if (index == ([_scrollViewImages count] - 1)) {
        self.startButton.hidden = NO;
    }else{
        self.startButton.hidden = YES;
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    if (index == ([_scrollViewImages count] - 1)) {
//        [self didClickStartButton:nil];
//    }
}

-(IBAction)didClickStartButton:(id)sender{
    [[NSUserDefaults standardUserDefaults] setObject:[AppSystem appVersion] forKey:kLastShownGuidanceVCAppVersion];
    if (self.completeBlock) {
        self.completeBlock();
    }
}

@end
