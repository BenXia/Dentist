//
//  LookHistoryVC.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "LookHistoryVC.h"
#import "FavoriteProductCell.h"
#import "ProductDetailVC.h"
#import "GetLookHistoryDC.h"
#import "RemoveLookHistoryDC.h"

static const CGFloat kItemNumPerLine = 2;

@interface LookHistoryVC ()<UICollectionViewDataSource,UICollectionViewDelegate,PPDataControllerDelegate>

@property (strong,nonatomic) GetLookHistoryDC* dc;
@property (strong,nonatomic) RemoveLookHistoryDC* removeDC;
@property (assign,nonatomic) BOOL isEditing;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign,nonatomic) CGFloat itemWidth;
@property (assign,nonatomic) CGFloat itemHeight;

@property (strong,nonatomic) NSMutableArray* selectedProductIds;

@end

@implementation LookHistoryVC

-(instancetype)init{
    if (self = [super init]) {
        self.title = @"浏览记录";
        self.selectedProductIds = [NSMutableArray new];
        self.dc = [[GetLookHistoryDC alloc]initWithDelegate:self];
        self.removeDC = [[RemoveLookHistoryDC alloc]initWithDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavRightItemWithName:@"编辑" target:self action:@selector(didClickEditButton)];
    [self initCollectionView];
    [self.dc requestWithArgs:nil];
    [self showLoadingView];
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

-(void)didClickEditButton{
    self.isEditing = YES;
    [self.collectionView reloadData];
    [self setNavRightItemWithName:@"删除" target:self action:@selector(didClickDeleteButton)];
}

-(void)didClickDeleteButton{
    if (self.selectedProductIds.count > 0) {
        QQingAlertView* alertView = [[QQingAlertView alloc]initWithTitle:nil message:@"确认要删除这些浏览记录吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView showWithDismissBlock:^(QQingAlertView *alertView, int dismissButtonIndex) {
            if (dismissButtonIndex == 1) {
                //确认删除
                self.removeDC.productIds = self.selectedProductIds;
                [self.removeDC requestWithArgs:nil];
                [Utilities showLoadingView];
            }
        }];
      
    }else{
        self.isEditing = NO;
        [self.collectionView reloadData];
        [self setNavRightItemWithName:@"编辑" target:self action:@selector(didClickEditButton)];
    }
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dc.products.count;
}

// 单元格代理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HistoryProductModel* model = [self.dc.products objectAtIndex:indexPath.row];
    FavoriteProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FavoriteProductCell" forIndexPath:indexPath];
    [cell setModel:model isEditing:self.isEditing isSelected:[self isSelectedProduct:model.iid]];
    
    return cell;
}

#pragma mark - UICollectionViewLayoutDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HistoryProductModel* model = [self.dc.products objectAtIndexIfIndexInBounds:indexPath.row];
    if (self.isEditing) {
        [self selectOrDeselectProduct:model.iid];
        [self.collectionView reloadData];
    }else{
        ProductDetailVC* detailVC = [[ProductDetailVC alloc] initWithProductId:model.iid];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
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

#pragma mark - PPDataControllerDelegate

//数据请求成功回调
- (void)loadingDataFinished:(PPDataController *)controller{
    [self hideLoadingView];
    [Utilities hideLoadingView];
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
    if (controller == self.dc) {
        [self.collectionView reloadData];
    }else if(controller == self.removeDC){
        [Utilities showToastWithText:@"删除浏览记录成功"];
        //本地删除
        self.dc.products = [self.dc.products arrayByRemoveObjectsIfKeyPath:@"iid" containInArray:self.selectedProductIds withEqualBlock:^BOOL(NSString* dst, NSString* src) {
            return [dst isEqualToString:src];
        }];
        
        self.isEditing = NO;
        [self.selectedProductIds removeAllObjects];
        [self.collectionView reloadData];
        [self setNavRightItemWithName:@"编辑" target:self action:@selector(didClickEditButton)];
    }
    
}
//数据请求失败回调
- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error{
    [self hideLoadingView];
    [Utilities hideLoadingView];
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
    if (controller == self.dc) {
        [Utilities showToastWithText:@"获取浏览记录列表失败"];
    }else if(controller == self.removeDC){
        [Utilities showToastWithText:@"删除浏览记录失败"];
        
        self.isEditing = NO;
        [self.selectedProductIds removeAllObjects];
        [self.collectionView reloadData];
        [self setNavRightItemWithName:@"编辑" target:self action:@selector(didClickEditButton)];
    }
}

#pragma mark - Private Method

- (BOOL)isSelectedProduct:(NSString*)productId {
    for (NSString* tmpId in self.selectedProductIds) {
        if ([tmpId isEqualToString:productId]) {
            return YES;
        }
    }
    return NO;
}

-(void)selectOrDeselectProduct:(NSString *)productId{
    if ([self isSelectedProduct:productId]) {
        [self.selectedProductIds removeObject:productId];
    } else {
        [self.selectedProductIds addObject:productId];
    }
}


@end
