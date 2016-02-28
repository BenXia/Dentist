//
//  CategoryVC.m
//  Dentist
//
//  Created by Ben on 16/1/10.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "CategoryVC.h"
#import "MultilevelMenu.h"
#import "ProductCategoryDC.h"
#import "ProductCategoryModel.h"
#import "SubCategoryVC.h"
#import "SearchProductVC.h"

@interface CategoryVC ()<PPDataControllerDelegate,WTLabelDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchContentView;
@property (nonatomic, strong) ProductCategoryDC *productCategoryRequest;
@property (nonatomic, strong) WTLabel *blankLabel;
@end

@implementation CategoryVC

#pragma mark - View life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"分类表";
        self.tabBarItem.title = @"分类";
        self.tabBarItem.image = [UIImage imageNamed:@"btn_classification_f"];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_classification_t"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clearNavLeftItem];
    [self initNavigationBar];
    [self downloadFromNet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Action

-(IBAction)didClickOnSearchView{
    SearchProductVC* searchVC = [SearchProductVC new];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - Private Method

- (void)downloadFromNet {
    self.productCategoryRequest = [[ProductCategoryDC alloc] initWithDelegate:self];
    self.productCategoryRequest.md5 = [[UserCache sharedUserCache] md5];
    [self.productCategoryRequest requestWithArgs:nil];
}

- (void)initNavigationBar {
    self.searchContentView.backgroundColor = RGBA(239, 240, 241, 0.8);
    self.searchContentView.layer.cornerRadius = (kScreenWidth > 320) ? 8 : 6;
    self.searchContentView.layer.masksToBounds = YES;
}

- (void)refreshView {
    NSMutableArray * lis=[NSMutableArray arrayWithCapacity:0];
    
    /**
     *  构建需要数据 2层或者3层数据 (ps 2层也当作3层来处理)
     */
    for (int i=0; i<self.productCategoryRequest.productCategoryArray.count; i++) {
        ProductCategoryModel *model = self.productCategoryRequest.productCategoryArray[i];
        rightMeun * meun=[[rightMeun alloc] init];
        meun.meunName = model.name;
        meun.ID = model.cid;
        NSMutableArray * sub=[NSMutableArray arrayWithCapacity:0];
        for ( int j=0; j < 1; j++) {
            
            rightMeun * meun1=[[rightMeun alloc] init];
            meun1.meunName = @"";
            
            [sub addObject:meun1];
            
            //meun.meunNumber=2;
            
            NSMutableArray *zList=[NSMutableArray arrayWithCapacity:0];
            for ( int z=0; z <model.subCategoryArray.count; z++) {
                ProductCategoryModel *subModel = model.subCategoryArray[z];
                rightMeun * meun2=[[rightMeun alloc] init];
                meun2.meunName = subModel.name;
                meun2.urlName = subModel.image_url;
                meun2.ID = subModel.cid;
                [zList addObject:meun2];
            }
            
            meun1.nextArray=zList;
        }
        
        
        meun.nextArray=sub;
        [lis addObject:meun];
    }
    
    /**
     *  适配 ios 7 和ios 8 的 坐标系问题
     */
    self.automaticallyAdjustsScrollViewInsets=NO;
    @weakify(self);
    MultilevelMenu * view=[[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64 - kTabBarHeight) WithData:lis withSelectIndex:^(NSInteger left, NSInteger right,rightMeun* info) {
        @strongify(self);
        //跳转到子分类
        NSLog(@"点击的 菜单%@",info.meunName);
        ProductCategoryModel *homeMeun = self.productCategoryRequest.productCategoryArray[left];
        int cid = [homeMeun.cid intValue];
        int scid = [info.ID intValue];
        NSString* scidTitle = info.meunName;
        SubCategoryVC* subCategoryVC = [[SubCategoryVC alloc] initWithCid:@(cid) scid:@(scid) title:scidTitle];
        subCategoryVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:subCategoryVC animated:YES];
    }];
    
    
    view.needToScorllerIndex=0;
    
    view.isRecordLastScroll=YES;
    [self.view addSubview:view];

}

#pragma mark - PPDataControllerDelegate

- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error {
    if (controller == self.productCategoryRequest) {
        [Utilities showToastWithText:[NSString stringWithFormat:@"获取分类信息失败"]];
        self.blankLabel.hidden = NO;
    }
}

- (void)loadingDataFinished:(PPDataController *)controller {
    if (controller == self.productCategoryRequest) {
        [[GCDQueue mainQueue] queueBlock:^{
            if (self.productCategoryRequest.responseCode == 200) {
                self.blankLabel.hidden = YES;
                [self refreshView];
            } else {
                [Utilities showToastWithText:[NSString stringWithFormat:@"获取分类信息失败"]];
            }
            
        }];
    }
}

#pragma mark - Navigation Style

//- (UIColor*)preferNavBarBackgroundColor{
//    return [UIColor themeBlueColor];
//}
//
//- (UIColor*)preferNavBarNormalTitleColor{
//    return [UIColor whiteColor];
//}

- (UIColor*)preferNavBarHighlightedTitleColor {
    return kWhiteHighlightedColor;
}

#pragma mark - WTLabelDelegate

- (void)didClickOnBtn {
    [self downloadFromNet];
}

#pragma mark - Setters and Getters

- (WTLabel *)blankLabel {
    if (!_blankLabel) {
        _blankLabel = [[WTLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 200) withTitle:@"网络不好" andSubTitle:@"请重新刷新一下吧" andButtonTitle:nil andIcon:@"头像"];
        _blankLabel.y = kBlankOldY;
        _blankLabel.centerX = [UIUtils screenWidth]/2;
        [_blankLabel setButtonTitle:@"刷新"];
        [_blankLabel.btn liningThematized:[UIColor themeButtonBlueColor]];
        _blankLabel.delegate = self;
        _blankLabel.hidden = YES;
        [self.view addSubview:_blankLabel];
    }
    return _blankLabel;
}

@end
