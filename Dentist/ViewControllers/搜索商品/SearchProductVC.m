//
//  SearchProductVC.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/25.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "SearchProductVC.h"
#import "SearchProductDC.h"
#import "ProductDetailVC.h"
#import "FavoriteProductCell.h"

static const CGFloat kItemNumPerLine = 2;

@interface SearchProductVC ()<PPDataControllerDelegate>

@property (strong,nonatomic) SearchProductDC* dc;

@property (weak, nonatomic) IBOutlet UISearchBar* searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign,nonatomic) CGFloat itemWidth;
@property (assign,nonatomic) CGFloat itemHeight;

@property (strong,nonatomic) NSString* searchKey;

@end

@implementation SearchProductVC

-(instancetype)init{
    if (self = [super init]) {
        self.dc = [[SearchProductDC alloc]initWithDelegate:self];
        self.title = @"搜索商品";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initCollectionView];
    
    if (self.firstSearchKey.length > 0) {
        self.dc.searchKey = self.firstSearchKey;
        self.searchBar.text = self.firstSearchKey;
        [self.dc requestWithArgs:nil];
        [Utilities showLoadingView];
    }else{
        [self.searchBar becomeFirstResponder];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Init

-(void)initCollectionView{
    self.view.backgroundColor = [UIColor themeBackGrayColor];
    self.collectionView.backgroundColor = [UIColor themeBackGrayColor];
    
    UINib* cellNib = [UINib nibWithNibName:@"FavoriteProductCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"FavoriteProductCell"];
    
    self.itemWidth = floorf((kScreenWidth - (kItemNumPerLine+1)*PIXEL_12) / kItemNumPerLine);
    self.itemHeight = self.itemWidth + 80;
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.collectionView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
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
    
    SearchProductModel* model = [self.dc.products objectAtIndex:indexPath.row];
    FavoriteProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FavoriteProductCell" forIndexPath:indexPath];
    [cell setModel:model isEditing:NO isSelected:NO];
    
    return cell;
}

#pragma mark - UICollectionViewLayoutDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchProductModel* model = [self.dc.products objectAtIndexIfIndexInBounds:indexPath.row];
    ProductDetailVC* detailVC = [[ProductDetailVC alloc] initWithProductId:model.iid];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(PIXEL_12,PIXEL_12,0, PIXEL_12);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.itemWidth, self.itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return PIXEL_12;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (self.searchBar.text.length > 0) {
        self.dc.searchKey = self.searchBar.text;
        [self.dc requestWithArgs:nil];
        [Utilities showLoadingView];
    }else{
        [Utilities showToastWithText:@"请输入搜索内容"];
    }
    [self.searchBar resignFirstResponder];
}

#pragma mark - PPDataControllerDelegate

//数据请求成功回调
- (void)loadingDataFinished:(PPDataController *)controller{
    [Utilities hideLoadingView];
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
    if (controller == self.dc) {
        [self.collectionView reloadData];
    }
}
//数据请求失败回调
- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error{
    [Utilities hideLoadingView];
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
    if (controller == self.dc) {
        [Utilities showToastWithText:@"获取搜索结果失败"];
    }
}

@end
