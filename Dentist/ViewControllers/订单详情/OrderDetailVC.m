//
//  ProductDetailVC.m
//  Dentist
//
//  Created by Ben on 2/21/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "OrderDetailVC.h"
#import "OrderDetailVM.h"
#import "OrderDetailModel.h"
#import "OrderListTableViewCell.h"
#import "ProductListModel.h"
#import "AllOrderListVM.h"
#import "OrderDetailDC.h"
#import "OrderConfermDC.h"
#import "FeedbackVC.h"
#import "OrderItemModel.h"
#import "OrderVC.h"

#define kTableViewCellHeight        95
#define kSectionHeaderViewHeight    40
#define kSectionFooterViewHeight    40
#define kDeleteButtonWidth          30
#define kDeleteButtonHeight         40
#define kPayButtonWidth             100
#define kPayButtonHeight            30
#define kInsert                     10

@interface OrderDetailVC ()<PPDataControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView  *tableHeaderView;
@property (weak,   nonatomic) IBOutlet UILabel *orderStateLabel;
@property (weak,   nonatomic) IBOutlet UILabel *orderShowNumberLabel;
@property (weak,   nonatomic) IBOutlet UILabel *expressCompanyLabel;
@property (weak,   nonatomic) IBOutlet UILabel *receiverNameLabel;
@property (weak,   nonatomic) IBOutlet UILabel *receiverPhoneLabel;
@property (weak,   nonatomic) IBOutlet UILabel *receiverAddressLabel;

@property (strong, nonatomic) IBOutlet UIView  *tableViewTimeView;
@property (weak,  nonatomic)  IBOutlet UILabel *purchaseTimeLabel;
@property (weak,  nonatomic)  IBOutlet UILabel *makeSureOrderTimeLabel;

@property (weak,   nonatomic) IBOutlet UIView   *bottomView;
@property (weak,   nonatomic) IBOutlet UIButton *receiverProductButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomContrainst;
@property (strong, nonatomic) OrderDetailVM *orderDetailVM;

@end

@implementation OrderDetailVC

- (id)initWithOid:(NSString *)oid {
    if (self = [super init]) {
        self.orderDetailVM.orderDetailDC = [[OrderDetailDC alloc] initWithDelegate:self];
        self.orderDetailVM.orderConfermDC = [[OrderConfermDC alloc] initWithDelegate:self];

        self.orderDetailVM.orderDetailDC.oid = oid;
        self.orderDetailVM.orderConfermDC.oid = oid;

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initObserver];
    [self initData];
    
}

- (void)initUI {
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor backGroundGrayColor];
    self.bottomView.hidden = YES;
    self.receiverProductButton.layer.cornerRadius = self.receiverProductButton.frame.size.height/2;
    [self.receiverProductButton.layer masksToBounds];
}

#pragma mark - Notification

- (void)initObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:kOrderChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:kNotificationAppraiseSuccess
                                               object:nil];
}

- (void)handleNotification:(NSNotification *)notification {
    if ([notification.name isEqualToString:kOrderChangedNotification]) {
        self.orderDetailVM.orderDetailDC.orderDetailModel.orderStatus = @"1";
        [self loadingDataFinished:self.orderDetailVM.orderDetailDC];
    } else {
        self.orderDetailVM.orderDetailDC.orderDetailModel.orderStatus = @"4";
        [self loadingDataFinished:self.orderDetailVM.orderDetailDC];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ButtonAction

- (IBAction)buttonAction:(id)sender {
    switch ([self.orderDetailVM.orderDetailDC.orderDetailModel.orderStatus intValue]) {
        case 0: {
            //跳转立即支付
            OrderVC *vc = [[OrderVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [vc setOrderId:self.orderDetailVM.orderDetailDC.oid];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        case 4:
        case 9:
        case 10: {
            //按钮隐藏
        }
            break;
        case 2: {
            //确认收货
            [self orderConfermRequest];
        }
            break;
        case 3: {
            //跳转评价
            NSArray* productArray = self.orderDetailVM.orderDetailDC.orderDetailModel.orderProductListModel.productListGoodsArray;
            FeedbackVC* feedbackVC = [[FeedbackVC alloc] initWithOrderId:self.orderDetailVM.orderDetailDC.oid products:productArray];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - PPDataControllerDelegate

- (void)initData {
    [self showLoadingView];
    self.tableView.hidden = YES;
    [self.orderDetailVM.orderDetailDC requestWithArgs:nil];
}

- (void)orderConfermRequest {
    [self showLoadingView];
    
    [self.orderDetailVM.orderConfermDC requestWithArgs:nil];
}

//数据请求成功回调
- (void)loadingDataFinished:(PPDataController *)controller{
    [self hideLoadingView];
    if ([controller isKindOfClass:[OrderDetailDC class]]) {
        self.tableView.hidden = NO;
        
        switch ([self.orderDetailVM.orderDetailDC.orderDetailModel.orderStatus intValue]) {
            case 0: {
                self.orderStateLabel.text = @"待支付";
                [self.receiverProductButton setTitle:@"立即支付" forState:UIControlStateNormal];
                self.bottomView.hidden = NO;
            }
                break;
            case 1: {
                self.orderStateLabel.text = @"已支付,待发货";
                self.tableView.tableFooterView = self.tableViewTimeView;
                self.tableViewBottomContrainst.constant = 0;
                self.bottomView.hidden = YES;
            }
                break;
            case 2: {
                self.orderStateLabel.text = @"已发货,待收货";
                self.bottomView.hidden = NO;
            }
                break;
            case 3: {
                self.orderStateLabel.text = @"已收货,待评价";
                [self.receiverProductButton setTitle:@"立即评价" forState:UIControlStateNormal];
                self.bottomView.hidden = NO;
            }
                break;
            case 4: {
                self.orderStateLabel.text = @"已评价";
                self.tableView.tableFooterView = self.tableViewTimeView;
                self.tableViewBottomContrainst.constant = 0;
                self.bottomView.hidden = YES;
                
            }
                break;
            case 9: {
                self.orderStateLabel.text = @"已退款";
                self.tableView.tableFooterView = self.tableViewTimeView;
                self.tableViewBottomContrainst.constant = 0;
                self.bottomView.hidden = YES;
            }
                break;
            case 10: {
                self.orderStateLabel.text = @"已关闭";
                self.tableView.tableFooterView = self.tableViewTimeView;
                self.tableViewBottomContrainst.constant = 0;
                self.bottomView.hidden = YES;
            }
                break;
                
            default:
                break;
        }
        
        self.tableView.tableHeaderView = self.tableHeaderView;
        
        if ([self.orderDetailVM.orderDetailDC.orderDetailModel.pickUp intValue] == 0) {
            self.expressCompanyLabel.text = self.orderDetailVM.orderDetailDC.orderDetailModel.orderExpressCompany;
            self.orderShowNumberLabel.text = self.orderDetailVM.orderDetailDC.orderDetailModel.orderShowNumber;
        } else {
            self.expressCompanyLabel.text = @"买家自提";
            self.orderShowNumberLabel.text = self.orderDetailVM.orderDetailDC.orderDetailModel.orderPickUpCode;
        }
        
        self.receiverNameLabel.text = self.orderDetailVM.orderDetailDC.orderDetailModel.orderReceiverName;
        
        self.receiverPhoneLabel.text = [NSString stringWithFormat:@"电话:%@",self.orderDetailVM.orderDetailDC.orderDetailModel.orderReceiverPhone];
        
        self.receiverAddressLabel.text = self.orderDetailVM.orderDetailDC.orderDetailModel.orderReceiverAddress;
        
        self.purchaseTimeLabel.text = self.orderDetailVM.orderDetailDC.orderDetailModel.orderPayTime;
        
        self.makeSureOrderTimeLabel.text = self.orderDetailVM.orderDetailDC.orderDetailModel.orderProduceTime;
        
        [self.tableView reloadData];
    } else if ([controller isKindOfClass:[OrderConfermDC class]]){
        //订单确认收货
        self.orderDetailVM.orderDetailDC.orderDetailModel.orderStatus = @"3";
        [self loadingDataFinished:self.orderDetailVM.orderDetailDC];
        [Utilities showToastWithText:@"确认收货成功"];
    }
}

//数据请求失败回调
- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error{
    [self hideLoadingView];
    [Utilities showToastWithText:@"订单详情获取失败"];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self createSectionHeaderViewWithProductListModel:self.orderDetailVM.orderDetailDC.orderDetailModel.orderProductListModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionHeaderViewHeight + 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self createSectionFooterViewWithProductListModel:self.orderDetailVM.orderDetailDC.orderDetailModel.orderProductListModel withSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterViewHeight + 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderDetailVM.orderDetailDC.orderDetailModel.orderProductListModel.productListGoodsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"OrderListTableViewCell";
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderListTableViewCell" owner:nil options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ProductListModel *model = self.orderDetailVM.orderDetailDC.orderDetailModel.orderProductListModel;
    [cell setModelWithProductListGoodsModel:[model.productListGoodsArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Data Init

- (UIView *)createSectionHeaderViewWithProductListModel:(ProductListModel *)productListModel {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionFooterViewHeight + 20)];

    UIView *sectionHeaderBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kSectionHeaderViewHeight)];
    sectionHeaderBackView.backgroundColor = [UIColor whiteColor];
    
    UILabel *orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kInsert, 0, kScreenWidth - kInsert,kSectionHeaderViewHeight)];
    orderNumLabel.font = [UIFont systemFontOfSize:13];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"订单号:%@",productListModel.orderID]];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor gray005Color]
                          range:NSMakeRange(0, 4)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor gray007Color]
                          range:NSMakeRange(4, AttributedStr.length - 4)];
    orderNumLabel.attributedText = AttributedStr;
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kSectionHeaderViewHeight - 1, kScreenWidth, 1)];
    lineImageView.backgroundColor = [UIColor gray003Color];
    
    [sectionHeaderBackView addSubview:orderNumLabel];
    [sectionHeaderBackView addSubview:lineImageView];
    
    [sectionHeaderView addSubview:sectionHeaderBackView];
    return sectionHeaderView;
}

- (UIView *)createSectionFooterViewWithProductListModel:(ProductListModel *)productListModel
                                            withSection:(NSInteger)section {
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionFooterViewHeight + 20)];
    
    UIView *sectionFooterBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionFooterViewHeight)];
    sectionFooterBackView.backgroundColor = [UIColor whiteColor];
    
    UILabel     *descriptionLabel = [self createDescriptionLabel:productListModel];
    UIImageView *lineImageView    = [self createLineImageView];
    
    [sectionFooterBackView addSubview:descriptionLabel];
    [sectionFooterBackView addSubview:lineImageView];
    
    [sectionFooterView addSubview:sectionFooterBackView];
    return sectionFooterView;
}

//创建订单整体描述的label
- (UILabel *)createDescriptionLabel:(ProductListModel *)productListModel {
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kInsert, 0, kScreenWidth, kSectionFooterViewHeight)];
    descriptionLabel.textColor = [UIColor gray006Color];
    descriptionLabel.font = [UIFont systemFontOfSize:13];
    if (productListModel.productExpressPrice.floatValue > 0) {
        descriptionLabel.text = [NSString stringWithFormat:@"共%lu件商品;合计:%.2f元(含快递费 %.2f元)",(unsigned long)productListModel.productListGoodsArray.count,[AllOrderListVM getOrderTotalPriceWithProductListModel:productListModel],[productListModel.productExpressPrice floatValue]];
    } else {
        descriptionLabel.text = [NSString stringWithFormat:@"共%lu件商品;合计:%.2f元",(unsigned long)productListModel.productListGoodsArray.count,[AllOrderListVM getOrderTotalPriceWithProductListModel:productListModel]];
    }
    return descriptionLabel;
}

//创建高度为1的横线
- (UIImageView *)createLineImageView {
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kSectionFooterViewHeight, kScreenWidth, 1)];
    lineImageView.backgroundColor = [UIColor gray003Color];
    return lineImageView;
}

- (OrderDetailVM *)orderDetailVM {
    if (_orderDetailVM == nil) {
        _orderDetailVM = [OrderDetailVM new];
    }
    return _orderDetailVM;
}
@end
