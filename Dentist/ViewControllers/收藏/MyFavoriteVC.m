//
//  MyFavoriteVC.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "MyFavoriteVC.h"
#import "MyFavoriteDC.h"
#import "RemoveFavoriteDC.h"
#import "FavoriteProductCell.h"

const CGFloat kItemNumPerLine = 2;

@interface MyFavoriteVC ()<UICollectionViewDataSource,UICollectionViewDelegate,PPDataControllerDelegate>

@property (strong,nonatomic) MyFavoriteDC* dc;
@property (strong,nonatomic) RemoveFavoriteDC* removeFavoriteDC;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign,nonatomic) CGFloat itemWidth;
@property (assign,nonatomic) CGFloat itemHeight;

@end

@implementation MyFavoriteVC

-(instancetype)init{
    if (self = [super init]) {
        self.dc = [[MyFavoriteDC alloc]initWithDelegate:self];
        self.removeFavoriteDC = [[RemoveFavoriteDC alloc]initWithDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initCollectionView];
    [self.dc requestWithArgs:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Init

-(void)initCollectionView{
    self.view.backgroundColor = [UIColor gray002Color];
    self.collectionView.backgroundColor = [UIColor gray002Color];
    
    self.itemWidth = floorf((kScreenWidth - (kItemNumPerLine+1)*PIXEL_12) / kItemNumPerLine);
    self.itemHeight = 100;
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.collectionView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.collectionView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.collectionView.headerPullToRefreshText = @"下拉刷新";
    self.collectionView.headerReleaseToRefreshText = @"松开就可以刷新了";
    self.collectionView.headerRefreshingText = @"正在刷新";
    
    self.collectionView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.collectionView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.collectionView.footerRefreshingText = @"正在加载中";
}

#pragma mark - UI Action

-(void)headerRereshing{
    self.dc.next_iid = nil;
    [self.dc requestWithArgs:nil];
}

-(void)footerRereshing{
    [self.dc requestWithArgs:nil];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dc.products.count;
}

// 单元格代理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"" forIndexPath:indexPath];
    
    
    return cell;
}

#pragma mark - UICollectionViewLayoutDelegate

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(PIXEL_12,PIXEL_12,0, PIXEL_12);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.itemWidth, self.itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return PIXEL_12;
}

#pragma mark - PPDataControllerDelegate

//数据请求成功回调
- (void)loadingDataFinished:(PPDataController *)controller{
    if (controller == self.dc) {
        [self.collectionView reloadData];
    }else if(controller == self.removeFavoriteDC){
        [Utilities showToastWithText:@"删除收藏成功"];
    }
    
}
//数据请求失败回调
- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error{
    if (controller == self.dc) {
        [Utilities showToastWithText:@"获取收藏列表失败"];
    }else if(controller == self.removeFavoriteDC){
        [Utilities showToastWithText:@"删除收藏失败"];
    }
}


@end
