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



#define kTableViewCellHeight        95
#define kSectionHeaderViewHeight    40
#define kSectionFooterViewHeight    40
#define kDeleteButtonWidth          30
#define kDeleteButtonHeight         40
#define kPayButtonWidth             100
#define kPayButtonHeight            30
#define kInsert                     10

@interface OrderDetailVC ()
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

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    
    ProductListModel *model = [ProductListModel new];
    model.orderID = @"1111";
    model.orderShowNumber = @"1565465489469468";
    model.statusCode = @"0";
    model.productExpressPrice = @"12";
    model.productListGoodsArray = [NSMutableArray new];
    
    
    ProductListGoodsModel *goodmodel = [ProductListGoodsModel new];
    goodmodel.productTitle = @"松开就可以刷新开开就开就可以刷新可以刷新就可以刷新了";
    goodmodel.productColor = @"绿色";
    goodmodel.productModel = @"w125 jhs455";
    goodmodel.productPrice = @"200";
    goodmodel.productNumber = @"2";
    goodmodel.productImageUrl = @"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=壁纸&pn=7&spn=0&di=153726435720&pi=&rn=1&tn=baiduimagedetail&istype=&ie=utf-8&oe=utf-8&in=3354&cl=2&lm=-1&st=&cs=545228853%2C2699540663&os=3179416101%2C3232832399&simid=4143495518%2C553170011&adpicid=0&ln=1000&fmq=1378374347070_R&ic=0&s=0&se=&sme=&tab=&face=&ist=&jit=&statnum=wallpaper&cg=&bdtype=10&objurl=http%3A%2F%2Fpic5.nipic.com%2F20100121%2F4183722_103138000079_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bgtrtv_z%26e3Bv54AzdH3Ffi5oAzdH3FdAzdH3Fn9AzdH3F9kbwv9mnvk0w8ja8_z%26e3Bip4s&gsm=200001e";
    
    
    
    ProductListGoodsModel *goodmodel1 = [ProductListGoodsModel new];
    goodmodel1.productTitle = @"松开就可以刷新开开就开就可以刷新可以刷新就可以刷新了";
    goodmodel1.productColor = @"绿色";
    goodmodel1.productModel = @"w125 jhs455";
    goodmodel1.productPrice = @"300";
    goodmodel1.productNumber = @"3";
    goodmodel1.productImageUrl = @"http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=壁纸&pn=7&spn=0&di=153726435720&pi=&rn=1&tn=baiduimagedetail&istype=&ie=utf-8&oe=utf-8&in=3354&cl=2&lm=-1&st=&cs=545228853%2C2699540663&os=3179416101%2C3232832399&simid=4143495518%2C553170011&adpicid=0&ln=1000&fmq=1378374347070_R&ic=0&s=0&se=&sme=&tab=&face=&ist=&jit=&statnum=wallpaper&cg=&bdtype=10&objurl=http%3A%2F%2Fpic5.nipic.com%2F20100121%2F4183722_103138000079_2.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bgtrtv_z%26e3Bv54AzdH3Ffi5oAzdH3FdAzdH3Fn9AzdH3F9kbwv9mnvk0w8ja8_z%26e3Bip4s&gsm=200001e";
    
    [model.productListGoodsArray addObject:goodmodel];
    [model.productListGoodsArray addObject:goodmodel1];


    
    OrderDetailModel *orderDetailModel  = [OrderDetailModel new];
    orderDetailModel.orderStatus = @"1";
    orderDetailModel.orderShowNumber = @"1254564989879894";
    orderDetailModel.orderExpressCompany = @"圆通";
    orderDetailModel.orderPickUpCode = @"123564";
    orderDetailModel.orderExpressNumber = @"123 568 565 5698 123";
    orderDetailModel.orderReceiverName = @"小时候";
    orderDetailModel.orderReceiverAddress = @"上海市浦东新区百合去23栋川江花园445号";
    orderDetailModel.orderReceiverPhone = @"18651893427";
    orderDetailModel.orderPayTime = @"2016-2-10 15:20:36";
    orderDetailModel.orderProduceTime = @"2016-2-10 15:10:36";
    orderDetailModel.orderProductListModel = model;

    
    
    self.orderDetailVM.orderDetailModel = orderDetailModel;
    
    
    
    
    
    switch ([self.orderDetailVM.orderDetailModel.orderStatus intValue]) {
        case 0: {
            self.orderStateLabel.text = @"待支付";
            [self.receiverProductButton setTitle:@"立即支付" forState:UIControlStateNormal];
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
        }
            break;
        case 3: {
            self.orderStateLabel.text = @"已收货,待评价";
            [self.receiverProductButton setTitle:@"立即评价" forState:UIControlStateNormal];
        }
            break;
        case 4: {
            self.orderStateLabel.text = @"已评价";
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
    
    self.orderShowNumberLabel.text = self.orderDetailVM.orderDetailModel.orderShowNumber;
    if (self.orderDetailVM.orderDetailModel.orderExpressCompany.length > 0) {
        self.expressCompanyLabel.text = self.orderDetailVM.orderDetailModel.orderExpressCompany;
    } else {
        self.expressCompanyLabel.text = @"买家自提";
    }
    
    self.receiverNameLabel.text = self.orderDetailVM.orderDetailModel.orderReceiverName;
    
    self.receiverPhoneLabel.text = [NSString stringWithFormat:@"电话:%@",self.orderDetailVM.orderDetailModel.orderReceiverPhone];
    
    self.receiverAddressLabel.text = self.orderDetailVM.orderDetailModel.orderReceiverAddress;
    
    self.purchaseTimeLabel.text = self.orderDetailVM.orderDetailModel.orderPayTime;
    
    self.makeSureOrderTimeLabel.text = self.orderDetailVM.orderDetailModel.orderProduceTime;
    
    [self.tableView reloadData];
}

- (void)initUI {
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor backGroundGrayColor];
    self.receiverProductButton.layer.cornerRadius = self.receiverProductButton.frame.size.height/2;
    [self.receiverProductButton.layer masksToBounds];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self createSectionHeaderViewWithProductListModel:self.orderDetailVM.orderDetailModel.orderProductListModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionHeaderViewHeight + 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self createSectionFooterViewWithProductListModel:self.orderDetailVM.orderDetailModel.orderProductListModel withSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterViewHeight + 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderDetailVM.orderDetailModel.orderProductListModel.productListGoodsArray.count;
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
    
    ProductListModel *model = self.orderDetailVM.orderDetailModel.orderProductListModel;
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
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"订单号:%@",productListModel.orderShowNumber]];
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
    if (productListModel.productExpressPrice.length > 0) {
        descriptionLabel.text = [NSString stringWithFormat:@"共%lu件商品;合计:%d元(含快递费 %d元)",(unsigned long)productListModel.productListGoodsArray.count,[AllOrderListVM getOrderTotalPriceWithProductListModel:productListModel],[productListModel.productExpressPrice intValue]];
    } else {
        descriptionLabel.text = [NSString stringWithFormat:@"共%lu件商品;合计:%d元",(unsigned long)productListModel.productListGoodsArray.count,[AllOrderListVM getOrderTotalPriceWithProductListModel:productListModel]];
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
