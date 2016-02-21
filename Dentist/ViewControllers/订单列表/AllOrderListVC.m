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

#define kTableViewCellHeight        95
#define kSectionHeaderViewHeight    40
#define kSectionFooterViewHeight    80
#define kStatusLabelWidth           60
#define kDeleteButtonWidth          30
#define kDeleteButtonHeight         40
#define kPayButtonWidth             100
#define kPayButtonHeight            30
#define kInsert                     10

@interface AllOrderListVC ()

@property (strong, nonatomic)          AllOrderListVM *allOrderListVM;
@property (weak,   nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AllOrderListVC

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

    self.allOrderListVM.orderListArray = [NSMutableArray arrayWithObjects:model,nil];
    
    
    [self.tableView reloadData];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor backGroundGrayColor];
    self.title = @"全部订单";
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allOrderListVM.orderListArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self createSectionHeaderViewWithProductListModel:[self.allOrderListVM.orderListArray objectAtIndex:section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionHeaderViewHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self createSectionFooterViewWithProductListModel:[self.allOrderListVM.orderListArray objectAtIndex:section]
                                                 withSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterViewHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ProductListModel *model = [self.allOrderListVM.orderListArray objectAtIndex:section];
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
    
    ProductListModel *model = [self.allOrderListVM.orderListArray objectAtIndex:indexPath.section];
    [cell setModelWithProductListGoodsModel:[model.productListGoodsArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderDetailVC *orderDetailVC = [OrderDetailVC new];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}
#pragma mark - Button Action

- (void)deleteOrder:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self.allOrderListVM.orderListArray removeObjectAtIndex:btn.tag];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

- (void)payOrder:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"立即付款"]) {
        //跳转立即付款
    } else if ([btn.titleLabel.text isEqualToString:@"再次购买"]) {
        //跳转再次购买
    }
}

- (void)praiseOrder:(id)sender {
    UIButton *btn = (UIButton *)sender;
    //跳转评价晒单
}


#pragma mark - Data Init

- (UIView *)createSectionHeaderViewWithProductListModel:(ProductListModel *)productListModel {
    UIView *sectionHeaderBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionHeaderViewHeight)];
    sectionHeaderBackView.backgroundColor = [UIColor whiteColor];
    
    UILabel *orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(kInsert, 0, kScreenWidth - kInsert - kStatusLabelWidth,kSectionHeaderViewHeight)];
    orderNumLabel.font = [UIFont systemFontOfSize:13];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"订单号:%@",productListModel.orderShowNumber]];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor gray005Color]
                          range:NSMakeRange(0, 4)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor gray007Color]
                          range:NSMakeRange(4, AttributedStr.length - 4)];
    orderNumLabel.attributedText = AttributedStr;
    
    UILabel *orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - kStatusLabelWidth - kInsert, 0, kStatusLabelWidth,kSectionHeaderViewHeight)];
    orderStateLabel.textAlignment = NSTextAlignmentRight;
    orderStateLabel.font = [UIFont systemFontOfSize:13];
    orderStateLabel.textColor = [UIColor redColor];
    switch ([productListModel.statusCode intValue]) {
        case 0: {
            orderStateLabel.text = @"待付款";
        }
            break;
        case 1: {
            orderStateLabel.text = @"交易成功";
        }
            break;
        case 2: {
            orderStateLabel.text = @"已发货";
        }
            break;
        case 3: {
            orderStateLabel.text = @"交易失败";
        }
            break;

        default:
            break;
    }
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kSectionHeaderViewHeight - 1, kScreenWidth, 1)];
    lineImageView.backgroundColor = [UIColor gray003Color];

    [sectionHeaderBackView addSubview:orderNumLabel];
    [sectionHeaderBackView addSubview:orderStateLabel];
    [sectionHeaderBackView addSubview:lineImageView];
    
    return sectionHeaderBackView;
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
            return [self createSuccessSectionFooterView:productListModel
                                            withSection:section];
        }
            break;
        case 2: {
            return [self createDeliveredSectionFooterView:productListModel
                                              withSection:section];
        }
            break;
        case 3: {
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
    UIButton *payButton        = [self createPayButton:productListModel
                                           withSection:section
                                             withTitle:@"再次购买"];
    
    [sectionFooterBackView addSubview:descriptionLabel];
    [sectionFooterBackView addSubview:lineImageView];
    [sectionFooterBackView addSubview:payButton];
    
    return sectionFooterBackView;
}

//创建订单整体描述的label
- (UILabel *)createDescriptionLabel:(ProductListModel *)productListModel {
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kInsert, 0, kScreenWidth, kSectionFooterViewHeight/2)];
    descriptionLabel.textColor = [UIColor gray006Color];
    descriptionLabel.font = [UIFont systemFontOfSize:13];
    if (productListModel.productExpressPrice.length > 0) {
        descriptionLabel.text = [NSString stringWithFormat:@"共%lu件商品；合计：%d元(含快递费 %d元)",(unsigned long)productListModel.productListGoodsArray.count,[AllOrderListVM getOrderTotalPriceWithProductListModel:productListModel],[productListModel.productExpressPrice intValue]];
    } else {
        descriptionLabel.text = [NSString stringWithFormat:@"共%lu件商品；合计：%d元",(unsigned long)productListModel.productListGoodsArray.count,[AllOrderListVM getOrderTotalPriceWithProductListModel:productListModel]];
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
