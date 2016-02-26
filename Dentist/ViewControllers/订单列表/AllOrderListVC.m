//
//  AllOrderListVC.m
//  Dentist
//
//  Created by Ben on 2/20/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "AllOrderListVC.h"
#import "AllOrderListVM.h"
#import "ProductListModel.h"
#import "ProductListGoodsModel.h"
#import "OrderListTableViewCell.h"
#import "OrderDetailVC.h"
#import "OrderListDC.h"
#import "FeedbackVC.h"


#define kTableViewCellHeight        95
#define kSectionHeaderViewHeight    60
#define kSectionFooterViewHeight    80
#define kStatusLabelWidth           100
#define kDeleteButtonWidth          30
#define kDeleteButtonHeight         40
#define kPayButtonWidth             100
#define kPayButtonHeight            30
#define kInsert                     10

@interface AllOrderListVC ()<PPDataControllerDelegate>
@property (weak,   nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)          AllOrderListVM *allOrderListVM;

@end

@implementation AllOrderListVC

- (id)initWithOrderStatusType:(OrderStatusType)type {
    if (self = [super init]) {
        self.allOrderListVM.orderStatusType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initData];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor backGroundGrayColor];
    switch (self.allOrderListVM.orderStatusType) {
        case OrderStatusType_NeedHandle: {
            self.title = @"待处理订单";
        }
            break;
        case OrderStatusType_Complete: {
            self.title = @"已完成订单";
        }
            break;
        case OrderStatusType_NeedPraise: {
            self.title = @"待评价订单";
        }
            break;
        case OrderStatusType_All: {
            self.title = @"全部订单";
        }
            break;
            
        default:
            break;
    }
}

- (void)initData {
    [self showLoadingView];
    self.allOrderListVM.orderListDC = [[OrderListDC alloc] initWithDelegate:self];
    [self.allOrderListVM.orderListDC requestWithArgs:nil];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allOrderListVM.orderListDC.orderListArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self createSectionHeaderViewWithProductListModel:[self.allOrderListVM.orderListDC.orderListArray objectAtIndex:section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionHeaderViewHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self createSectionFooterViewWithProductListModel:[self.allOrderListVM.orderListDC.orderListArray objectAtIndex:section]
                                                 withSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterViewHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ProductListModel *model = [self.allOrderListVM.orderListDC.orderListArray objectAtIndex:section];
    return model.productListGoodsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"OrderListTableViewCell";
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderListTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    ProductListModel *model = [self.allOrderListVM.orderListDC.orderListArray objectAtIndex:indexPath.section];
    [cell setModelWithProductListGoodsModel:[model.productListGoodsArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProductListModel *model = [self.allOrderListVM.orderListDC.orderListArray objectAtIndex:indexPath.section];
    OrderDetailVC *orderDetailVC = [[OrderDetailVC alloc] initWithOid:model.orderID];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark - Button Action

- (void)deleteOrder:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self.allOrderListVM.orderListDC.orderListArray removeObjectAtIndex:btn.tag];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

- (void)payOrder:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"立即付款"]) {
        //跳转立即付款
    } else if ([btn.titleLabel.text isEqualToString:@"再次购买"]) {
        //跳转再次购买
        NSLog(@"再次购买");
    }
}

- (void)praiseOrder:(id)sender {
    UIButton *btn = (UIButton *)sender;
    //跳转评价晒单
    NSArray* orderArray = self.allOrderListVM.orderListDC.orderListArray;
    ProductListModel* model = [orderArray objectAtIndexIfIndexInBounds:btn.tag];
    FeedbackVC* feedbackVC = [[FeedbackVC alloc] initWithOrderId:model.orderID products:model.productListGoodsArray];
    [self.navigationController pushViewController:feedbackVC animated:YES];
}


#pragma mark - PPDataControllerDelegate

//数据请求成功回调
- (void)loadingDataFinished:(PPDataController *)controller{
    [self hideLoadingView];
    [self.allOrderListVM filterDataWithOrderStatusType];
    [self.tableView reloadData];
}

//数据请求失败回调
- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error{
    [self hideLoadingView];
    [Utilities showToastWithText:@"订单列表获取失败"];
}

#pragma mark - Data Init

- (UIView *)createSectionHeaderViewWithProductListModel:(ProductListModel *)productListModel {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionHeaderViewHeight)];
    sectionHeaderView.backgroundColor = [UIColor clearColor];
    
    UIView *sectionHeaderBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kSectionHeaderViewHeight - 20)];
    sectionHeaderBackView.backgroundColor = [UIColor whiteColor];
    
    UILabel *orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kInsert, 0, kScreenWidth - kInsert - kStatusLabelWidth,kSectionHeaderViewHeight - 20)];
    orderNumLabel.font = [UIFont systemFontOfSize:13];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"订单号:%@",productListModel.orderID]];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor gray005Color]
                          range:NSMakeRange(0, 4)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor gray007Color]
                          range:NSMakeRange(4, AttributedStr.length - 4)];
    orderNumLabel.attributedText = AttributedStr;
    
    UILabel *orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - kStatusLabelWidth - kInsert, 0, kStatusLabelWidth,kSectionHeaderViewHeight - 20)];
    orderStateLabel.textAlignment = NSTextAlignmentRight;
    orderStateLabel.font = [UIFont systemFontOfSize:13];
    orderStateLabel.textColor = [UIColor redColor];
    switch ([productListModel.statusCode intValue]) {
        case 0: {
            orderStateLabel.text = @"待付款";
        }
            break;
        case 1: {
            orderStateLabel.text = @"已支付,待发货";
        }
            break;
        case 2: {
            orderStateLabel.text = @"已发货,待收货";
        }
            break;
        case 3: {
            orderStateLabel.text = @"已收货,待评价";
        }
            break;
        case 4: {
            orderStateLabel.text = @"已评价";
        }
            break;
        case 10: {
            orderStateLabel.text = @"已关闭";
        }
            break;

        default:
            break;
    }
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kSectionHeaderViewHeight - 20 - 1, kScreenWidth, 1)];
    lineImageView.backgroundColor = [UIColor gray003Color];

    [sectionHeaderBackView addSubview:orderNumLabel];
    [sectionHeaderBackView addSubview:orderStateLabel];
    [sectionHeaderBackView addSubview:lineImageView];
    
    [sectionHeaderView addSubview:sectionHeaderBackView];
    
    return sectionHeaderView;
}

- (UIView *)createSectionFooterViewWithProductListModel:(ProductListModel *)productListModel
                                            withSection:(NSInteger)section {
    
    switch ([productListModel.statusCode intValue]) {
        case 0: {
            return [self createNeedPaymentSectionFooterView:productListModel
                                                withSection:section];
        }
            break;
        case 1: {
            return [self createDeliveredSectionFooterView:productListModel
                                              withSection:section];
        }
            break;
        case 2: {
            return [self createDeliveredSectionFooterView:productListModel
                                              withSection:section];
        }
            break;
        case 3: {
            return [self createSuccessSectionFooterView:productListModel
                                            withSection:section];
        }
            break;
        case 4: {
            return [self createDeliveredSectionFooterView:productListModel
                                              withSection:section];
        }
            break;
        case 10: {
            //交易关闭的footerview跟成功的一致
            return [self createSuccessSectionFooterView:productListModel
                                            withSection:section];
        }
            break;

        default:
            break;
    }
    return [UIView new];
}

- (UIView *)createNeedPaymentSectionFooterView:(ProductListModel *)productListModel
                                   withSection:(NSInteger)section {
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionFooterViewHeight + 20)];
    
    UIView *sectionFooterBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionFooterViewHeight)];
    sectionFooterBackView.backgroundColor = [UIColor whiteColor];

    UILabel     *descriptionLabel = [self createDescriptionLabel:productListModel];
    UIImageView *lineImageView    = [self createLineImageView];
    UIButton    *deleteButton     = [self createDeleteButton:productListModel
                                                 withSection:section];
    UIButton *payButton           = [self createPayButton:productListModel
                                              withSection:section
                                                withTitle:@"立即付款"];

    [sectionFooterBackView addSubview:descriptionLabel];
    [sectionFooterBackView addSubview:lineImageView];
    [sectionFooterBackView addSubview:deleteButton];
    [sectionFooterBackView addSubview:payButton];
    
    [sectionFooterView addSubview:sectionFooterBackView];
    return sectionFooterView;
}

- (UIView *)createSuccessSectionFooterView:(ProductListModel *)productListModel
                               withSection:(NSInteger)section {
    UIView *sectionFooterBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionFooterViewHeight)];
    sectionFooterBackView.backgroundColor = [UIColor whiteColor];

    UILabel *descriptionLabel   = [self createDescriptionLabel:productListModel];
    UIImageView *lineImageView  = [self createLineImageView];
    UIButton *deleteButton      = [self createDeleteButton:productListModel
                                               withSection:section];
    UIButton *payButton         = [self createPayButton:productListModel
                                            withSection:section
                                              withTitle:@"再次购买"];
    UIButton *praiseButton      = [self createPraiseButton:productListModel
                                               withSection:section];

    [sectionFooterBackView addSubview:descriptionLabel];
    [sectionFooterBackView addSubview:lineImageView];
    [sectionFooterBackView addSubview:deleteButton];
    [sectionFooterBackView addSubview:payButton];
    [sectionFooterBackView addSubview:praiseButton];

    return sectionFooterBackView;
}

- (UIView *)createDeliveredSectionFooterView:(ProductListModel *)productListModel
                                 withSection:(NSInteger)section{
    UIView *sectionFooterBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionFooterViewHeight)];
    sectionFooterBackView.backgroundColor = [UIColor whiteColor];

    UILabel *descriptionLabel  = [self createDescriptionLabel:productListModel];
    UIImageView *lineImageView = [self createLineImageView];
    UIButton *deleteButton      = [self createDeleteButton:productListModel
                                               withSection:section];
    UIButton *payButton        = [self createPayButton:productListModel
                                           withSection:section
                                             withTitle:@"再次购买"];
    
    [sectionFooterBackView addSubview:descriptionLabel];
    [sectionFooterBackView addSubview:lineImageView];
    [sectionFooterBackView addSubview:payButton];
    [sectionFooterBackView addSubview:deleteButton];

    return sectionFooterBackView;
}

//创建订单整体描述的label
- (UILabel *)createDescriptionLabel:(ProductListModel *)productListModel {
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kInsert, 0, kScreenWidth, kSectionFooterViewHeight/2)];
    descriptionLabel.textColor = [UIColor gray006Color];
    descriptionLabel.font = [UIFont systemFontOfSize:13];
    if (productListModel.productExpressPrice.floatValue > 0) {
        descriptionLabel.text = [NSString stringWithFormat:@"共%lu件商品；合计：%.2f元(含快递费 %.2f元)",(unsigned long)productListModel.productListGoodsArray.count,[AllOrderListVM getOrderTotalPriceWithProductListModel:productListModel],[productListModel.productExpressPrice floatValue]];
    } else {
        descriptionLabel.text = [NSString stringWithFormat:@"共%lu件商品；合计：%.2f元",(unsigned long)productListModel.productListGoodsArray.count,[AllOrderListVM getOrderTotalPriceWithProductListModel:productListModel]];
    }
    return descriptionLabel;
}

//创建高度为1的横线
- (UIImageView *)createLineImageView {
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kSectionFooterViewHeight/2, kScreenWidth, 1)];
    lineImageView.backgroundColor = [UIColor gray003Color];
    return lineImageView;
}

//创建删除按钮
- (UIButton *)createDeleteButton:(ProductListModel *)productListModel
                     withSection:(NSInteger)section {
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(kInsert, kSectionFooterViewHeight/2, kDeleteButtonWidth, kDeleteButtonHeight);
    [deleteButton setImage:[UIImage imageNamed:@"Btn_Delete_default"] forState:UIControlStateNormal];
    deleteButton.tag = section;
    [deleteButton addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
    return deleteButton;
}

//创建支付按钮
- (UIButton *)createPayButton:(ProductListModel *)productListModel
                  withSection:(NSInteger)section
                    withTitle:(NSString *)title {
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(kScreenWidth - kInsert - kPayButtonWidth, kSectionFooterViewHeight/2 + 5, kPayButtonWidth, kPayButtonHeight);
    [payButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [payButton setTitle:title forState:UIControlStateNormal];
    payButton.backgroundColor = [UIColor themeButtonBlueColor];
    payButton.layer.cornerRadius = payButton.height/2;
    payButton.layer.masksToBounds = YES;
    payButton.tag = section;
    [payButton addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
    return payButton;
}

//创建评价晒单按钮
- (UIButton *)createPraiseButton:(ProductListModel *)productListModel
                  withSection:(NSInteger)section {
    UIButton *praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    praiseButton.frame = CGRectMake(kScreenWidth - kInsert*2 - kPayButtonWidth*2, kSectionFooterViewHeight/2 + 5, kPayButtonWidth, kPayButtonHeight);
    [praiseButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [praiseButton setTitle:@"评价晒单" forState:UIControlStateNormal];
    praiseButton.layer.cornerRadius = praiseButton.height/2;
    praiseButton.layer.masksToBounds = YES;
    praiseButton.tag = section;
    [praiseButton addTarget:self action:@selector(praiseOrder:) forControlEvents:UIControlEventTouchUpInside];
    return praiseButton;
}

- (AllOrderListVM *)allOrderListVM {
    if (_allOrderListVM == nil) {
        _allOrderListVM = [AllOrderListVM new];
    }
    return _allOrderListVM;
}
@end
