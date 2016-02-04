//
//  CategoryVC.m
//  Dentist
//
//  Created by Ben on 16/1/10.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "CategoryVC.h"
#import "MultilevelMenu.h"

@interface CategoryVC ()
@property (weak, nonatomic) IBOutlet UIView *searchContentView;

@end

@implementation CategoryVC

#pragma mark - View life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)initData {
    
    NSMutableArray * lis=[NSMutableArray arrayWithCapacity:0];
    
    
    /**
     *  构建需要数据 2层或者3层数据 (ps 2层也当作3层来处理)
     */
    NSInteger countMax=6;
    for (int i=0; i<countMax; i++) {
        
        rightMeun * meun=[[rightMeun alloc] init];
        meun.meunName=[NSString stringWithFormat:@"菜单%d",i];
        NSMutableArray * sub=[NSMutableArray arrayWithCapacity:0];
        for ( int j=0; j < 1; j++) {
            
            rightMeun * meun1=[[rightMeun alloc] init];
            meun1.meunName = @"";
            
            [sub addObject:meun1];
            
            //meun.meunNumber=2;
            
            NSMutableArray *zList=[NSMutableArray arrayWithCapacity:0];
            for ( int z=0; z <countMax+2; z++) {
                
                rightMeun * meun2=[[rightMeun alloc] init];
                meun2.meunName=[NSString stringWithFormat:@"%d层菜单%d",i,z];
                
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
    
    /**
     默认是 选中第一行
     
     :returns: <#return value description#>
     */
    MultilevelMenu * view=[[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) WithData:lis withSelectIndex:^(NSInteger left, NSInteger right,rightMeun* info) {
        
        NSLog(@"点击的 菜单%@",info.meunName);
    }];
    
    
    view.needToScorllerIndex=0;
    
    view.isRecordLastScroll=YES;
    [self.view addSubview:view];
}

- (void)initNavigationBar {
    self.searchContentView.backgroundColor = RGBA(239, 240, 241, 0.8);
    self.searchContentView.layer.cornerRadius = (kScreenWidth > 320) ? 8 : 6;
    self.searchContentView.layer.masksToBounds = YES;
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

@end
