//
//  OrderVC.m
//  Dentist
//
//  Created by Ben on 16/2/15.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "OrderVC.h"
#import "OrderDetailDC.h"
#import "ProductListGoodsModel.h"
#import "ProductListModel.h"
#import "OrderReceiverCell.h"
#import "OrderItemHeaderCell.h"
#import "OrderItemCell.h"
#import "OrderItemFooterCell.h"
#import "OrderBottomInfoCell.h"
#import "InvoiceVC.h"
#import "DeliverTypeVC.h"
#import "PayTypeVC.h"
#import "AddressListVC.h"
#import "PPConfirmOrderDC.h"
#import "PPCreateOrderDC.h"
#import "DeleteOrderDC.h"
#import "PPRepayDC.h"
#import "PPPayResultDC.h"
#import "PaySuccessVC.h"
#import "PayFailedVC.h"
#import "WeiXinMD5Encrypt.h"
#import "AlipayManager.h"

@interface OrderVC () <
UITableViewDataSource,
UITableViewDelegate,
OrderBottomInfoCellDelegate,
DeliverTypeVCDelegate,
PayTypeVCDelegate,
InvoiceVCDelegate,
PPDataControllerDelegate,
PayFailedVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *noDeliverFeeLabel;

@property (nonatomic, strong) PPConfirmOrderDC *confirmOrderDC;
@property (nonatomic, strong) PPCreateOrderDC *createOrderDC;
@property (nonatomic, strong) DeleteOrderDC *deleteOrderDC;
@property (nonatomic, strong) PPPayResultDC *payResultDC;
@property (nonatomic, strong) PPRepayDC *repayDC;

@property (nonatomic, strong) Address *addressModel;
@property (nonatomic, strong) NSMutableArray *productItemsArray;

@property (nonatomic, strong) OrderDetailDC *orderDetailDC;
@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, assign) DeliverType deliverType;
@property (nonatomic, assign) double deliverPrice;

@property (nonatomic, assign) PayType payType;

@property (nonatomic, assign) int piaoType;
@property (nonatomic, strong) NSString *piaoTitle;
@property (nonatomic, strong) NSString *piaoContent;

@property (nonatomic, strong) NSString *feedbackText;

@property (nonatomic, strong) NSString *aliPayErrorDesc;

@end

@implementation OrderVC

#pragma mark - View life cycle

- (instancetype)init {
    if (self = [super init]) {
        self.confirmOrderDC = [[PPConfirmOrderDC alloc] init];
        self.confirmOrderDC.delegate = self;
        
        self.createOrderDC = [[PPCreateOrderDC alloc] init];
        self.createOrderDC.delegate = self;
        
        self.deleteOrderDC = [[DeleteOrderDC alloc] init];
        self.deleteOrderDC.delegate = self;
        
        self.payResultDC = [[PPPayResultDC alloc] init];
        self.payResultDC.delegate = self;
        
        self.repayDC = [[PPRepayDC alloc] init];
        self.repayDC.delegate = self;
        
        self.orderDetailDC = [[OrderDetailDC alloc] init];
        self.orderDetailDC.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUIReleated];
    
    if (!self.orderId) {
        [self.confirmOrderDC requestWithArgs:nil];
    } else {
        [Utilities showLoadingView];
        [self.orderDetailDC requestWithArgs:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public methods

- (void)setProductItemsArray:(NSMutableArray *)productItemsArray {
    _productItemsArray = productItemsArray;
    
    self.confirmOrderDC.productItemsArray = productItemsArray;
    self.createOrderDC.productItemsArray = productItemsArray;
}

- (void)setGroupId:(NSString *)groupIds {
    self.confirmOrderDC.groupIds = groupIds;
    self.createOrderDC.groupIds = groupIds;
}

- (void)setOrderId:(NSString *)orderId {
    _orderId = orderId;
    
    self.repayDC.oid = orderId;
    self.payResultDC.oid = orderId;
    self.createOrderDC.oid = orderId;
    self.orderDetailDC.oid = orderId;
}

#pragma mark - Setter methods

- (void)setPayType:(PayType)payType {
    _payType = payType;
    
    [self.tableView reloadData];
}

- (void)setDeliverType:(DeliverType)deliverType {
    _deliverType = deliverType;
    
    if (deliverType == DeliverType_ZiTi) {
        self.noDeliverFeeLabel.hidden = NO;
    } else {
        self.noDeliverFeeLabel.hidden = YES;
    }
    
    [self.tableView reloadData];
}

- (void)setDeliverPrice:(double)deliverPrice {
    _deliverPrice = deliverPrice;
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f", self.confirmOrderDC.goodsPrice + self.deliverPrice];
    
    [self.tableView reloadData];
}

- (void)setPiaoType:(int)piaoType {
    _piaoType = piaoType;
    
    [self.tableView reloadData];
}

- (void)setPiaoTitle:(NSString *)piaoTitle {
    _piaoTitle = piaoTitle;
    
    [self.tableView reloadData];
}

- (void)setPiaoContent:(NSString *)piaoContent {
    _piaoContent = piaoContent;
    
    [self.tableView reloadData];
}

#pragma mark - Private methods

- (void)initUIReleated {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.bottomContentView.layer.shadowOffset = CGSizeMake(2, -2);
    self.bottomContentView.layer.shadowOpacity = 0.2;
    self.bottomContentView.layer.shadowColor = [UIColor grayColor].CGColor;
    
    [self setNavTitleString:@"确认订单"];
    
    [self initTableView];
}

- (void)initTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderReceiverCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderReceiverCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderItemHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderItemHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderItemCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderItemFooterCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderItemFooterCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderBottomInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderBottomInfoCell"];
}

#pragma mark - WeXinPay API

- (void)weixinPayWithDict:(NSDictionary *)weixinDict {
    ComponentWechatPay_Order *order = component.payment.wechatpay.order;
    ComponentWechatPay_Config *config = component.payment.wechatpay.config;
    
    //weixin =     {
    //    appid = wx983825eaeef912b7;
    //    "mch_id" = 1292687201;
    //    "nonce_str" = NBe6LOSEsxxMSLDy;
    //    "prepay_id" = wx20160227000908562ac409430006092890;
    //    "result_code" = SUCCESS;
    //    "return_code" = SUCCESS;
    //    "return_msg" = OK;
    //    sign = 6BCA9F2B2BBA86A3187EEA1AE45FDE13;
    //    "trade_type" = APP;
    //};
    
    config.appId                    = [weixinDict objectForKey:@"appid"];
    config.partnerId                = [weixinDict objectForKey:@"mch_id"];
    order.package                   = @"Sign=WXPay";
    order.nonceStr                  = [weixinDict objectForKey:@"nonce_str"];
    order.prepayId                  = [weixinDict objectForKey:@"prepay_id"];
    order.sign                      = [weixinDict objectForKey:@"sign"];;
    
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    UInt32 timeStamp =[timeSp intValue];
    order.timeStamp = timeStamp;
    
    WeiXinMD5Encrypt *md5Generator = [[WeiXinMD5Encrypt alloc] init];
    order.sign = [md5Generator createMD5SingForPay:config.appId
                                         partnerid:config.partnerId
                                          prepayid:order.prepayId
                                           package:order.package
                                          noncestr:order.nonceStr
                                         timestamp:order.timeStamp];
    
    @weakify(self);
    ComponentWechatPay  *wechatpay  = component.payment.wechatpay;
    wechatpay.succeedHandler        = ^ (id object) {
        @strongify(self)
        
        [self.payResultDC requestWithArgs:nil];
    };
    wechatpay.failedHandler         = ^ (NSError *error) {
        [Utilities showToastWithText:@"支付未完成" withImageName:nil blockUI:NO];
    };
    [wechatpay pay];
}

#pragma mark - Alipay Related

- (void)alipayWithOrderId:(NSString *)orderId
                     name:(NSString *)name
              description:(NSString *)description
                    money:(NSString *)money {
    ComponentAlipay_Order *order = [[ComponentAlipay_Order alloc] init];
    order.ID = orderId;
    order.name = name;
    order.desc = description;
    order.price = money;
    [[AlipayManager sharedAlipayManager] payWithAlipay:order completeBlock:^(NSDictionary *dic) {
        [[GCDQueue mainQueue] queueBlock:^{
            [self alipayResult:dic];
        }];
    }];
}

- (void)alipayResult:(NSDictionary *)resultDict {
    NSNumber *status = [resultDict objectForKey:@"resultStatus"];
    switch ([status intValue]) {
        case kAlipayErrorCode_Succeed: {
            self.aliPayErrorDesc = @"支付宝支付成功";
            [self.payResultDC requestWithArgs:nil];
        }
            break;
            
        case kAlipayErrorCode_Dealing: {
            self.aliPayErrorDesc = @"支付订单正在处理中";
        }
            break;
            
        case kAlipayErrorCode_Failed: {
            self.aliPayErrorDesc = @"支付宝支付失败";
        }
            break;
            
        case kAlipayErrorCode_Cancel: {
            self.aliPayErrorDesc = @"支付订单取消";
        }
            break;
            
        case kAlipayErrorCode_NetError: {
            self.aliPayErrorDesc = @"网络连接失败";
        }
            
        default: {
            self.aliPayErrorDesc = @"支付未完成";
        }
            break;
    }
    
    [Utilities showToastWithText:self.aliPayErrorDesc withImageName:nil blockUI:NO];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productItemsArray.count + 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        OrderReceiverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderReceiverCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.receiverNameLabel.text = self.addressModel.recipientName ? self.addressModel.recipientName : @"收件人姓名";
        cell.receiverPhoneNumberLabel.text = self.addressModel.recipientPhoneNum ? self.addressModel.recipientPhoneNum : @"收件人电话";
        cell.receiverAddressLabel.text = self.addressModel.detailAddress ? self.addressModel.detailAddress : @"收件人地址";
        
        if (self.orderId) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    } else if (indexPath.row == 1) {
        OrderItemHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderItemHeaderCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == self.productItemsArray.count + 2) {
        OrderItemFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderItemFooterCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f", self.confirmOrderDC.goodsPrice + self.deliverPrice];
        int itemsCount = 0;
        for (OrderItemModel *model in self.confirmOrderDC.orderItemsArray) {
            itemsCount += model.buyNum;
        }
        
        cell.orderItemsCountLabel.text = [NSString stringWithFormat:@"%d", itemsCount];
        
        return cell;
    } else if (indexPath.row == self.productItemsArray.count + 3) {
        OrderBottomInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderBottomInfoCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        cell.deliveryLabel.text = (self.deliverType == DeliverType_KuaiDi) ? @"快递" : @"自提";
        cell.deliveryPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f", ((self.deliverType == DeliverType_KuaiDi) ? self.confirmOrderDC.kuaidiPrice : 0)];
        
        NSString *piaoInfoString = @"";
        if (self.piaoType == 0) {
            piaoInfoString = @"不开发票";
        } else if (self.piaoType == 1) {
            piaoInfoString = [NSString stringWithFormat:@"普通发票 %@ %@", self.piaoTitle, self.piaoContent];
        }
        
        cell.ticketInfoLabel.text = piaoInfoString;
        cell.feedbackTextField.text = self.feedbackText;
        
        cell.payTypeImageView.image = [UIImage imageNamed:((self.payType == PayType_WeChat) ? @"ic_pay_weixin.png" : @"pay_pic.png")];
        cell.payTypeLabel.text = (self.payType == PayType_WeChat) ? @"微信支付" : @"支付宝";
        
        if (self.orderId) {
            cell.feedbackTextField.userInteractionEnabled = NO;
        }
        
        return cell;
    } else {
        OrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderItemCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        OrderItemModel *model = [self.productItemsArray objectAtIndex:indexPath.row - 2];
        [cell.productImageView setImageURL:[NSURL URLWithString:model.productImageUrl]];
        cell.productTitleLabel.text = model.productTitle;
        cell.productCustomiseLabel.text = model.descriptionString;
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", model.productPrice];
        cell.productNumberLabel.text = [NSString stringWithFormat:@"x %d", model.buyNum];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [OrderReceiverCell heightWithAddress:self.addressModel.detailAddress ? self.addressModel.detailAddress : @"收件人地址"];
    } else if (indexPath.row == 1) {
        return 50;
    } else if (indexPath.row == self.productItemsArray.count + 2) {
        return 40;
    } else if (indexPath.row == self.productItemsArray.count + 3) {
        return 230;
    } else {
        return 96;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (!self.orderId) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            AddressListVC *vc = [[AddressListVC alloc] init];
            vc.isSelectAddress = YES;
            vc.selectedCompleteBlock = ^(Address *address) {
                self.addressModel = address;
                
                [[GCDQueue mainQueue] queueBlock:^{
                    [self.tableView reloadData];
                }];
            };
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - IBActions

- (IBAction)didClickPayNowButtonAction:(id)sender {
    if (!self.orderId) {
        if (self.addressModel.ID.length == 0) {
            [Utilities showToastWithText:@"请先填写收件地址" withImageName:nil blockUI:NO];
            return;
        }
        
        if (!self.createOrderDC.oid) {
            [self handleCreateOrderAction];
        } else {
            NSString *orderExpress = (self.deliverType == DeliverType_KuaiDi) ? @"express" : @"pick_up";
            NSString *aid = self.addressModel.ID;
            NSString *piaoType = [NSString stringWithFormat:@"%d", self.piaoType];
            NSString *piaoTitle = self.piaoTitle ? self.piaoTitle : @"";
            NSString *piaoContent = self.piaoContent ? self.piaoContent : @"";
            NSString *remarkNum = self.feedbackText ? self.feedbackText : @"";
            
            if ([self.createOrderDC.orderExpress isEqualToString:orderExpress] &&
                [self.createOrderDC.aid isEqualToString:aid] &&
                [self.createOrderDC.piaoType isEqualToString:piaoType] &&
                [self.createOrderDC.piaoTitle isEqualToString:piaoTitle] &&
                [self.createOrderDC.piaoContent isEqualToString:piaoContent] &&
                [self.createOrderDC.remarkNum isEqualToString:remarkNum]) {
                
                self.repayDC.oid = self.createOrderDC.oid;
                self.repayDC.payType = (self.payType == PayType_WeChat) ? @"weixin" : @"alipay";
                
                [self.repayDC requestWithArgs:nil];
            } else {
                [self handleDeleteCurrentCreateOrderAction];
            }
        }
    } else {
        self.repayDC.oid = self.createOrderDC.oid;
        self.repayDC.payType = (self.payType == PayType_WeChat) ? @"weixin" : @"alipay";
        
        [self.repayDC requestWithArgs:nil];
    }
}

- (void)handleDeleteCurrentCreateOrderAction {
    self.deleteOrderDC.oid = self.createOrderDC.oid;
    
    [self.deleteOrderDC requestWithArgs:nil];
}

- (void)handleCreateOrderAction {
    self.createOrderDC.orderExpress = (self.deliverType == DeliverType_KuaiDi) ? @"express" : @"pick_up";
    self.createOrderDC.aid = self.addressModel.ID;
    self.createOrderDC.payType = (self.payType == PayType_WeChat) ? @"weixin" : @"alipay";
    self.createOrderDC.orderCertArray = @[];
    self.createOrderDC.piaoType = [NSString stringWithFormat:@"%d", self.piaoType];
    self.createOrderDC.piaoTitle = self.piaoTitle ? self.piaoTitle : @"";
    self.createOrderDC.piaoContent = self.piaoContent ? self.piaoContent : @"";
    self.createOrderDC.remarkNum = self.feedbackText ? self.feedbackText : @"";
    
    [self.createOrderDC requestWithArgs:nil];
}

#pragma mark - OrderBottomInfoCellDelegate

- (void)didChangeFeedbackTextTo:(NSString *)feedbackText {
    self.feedbackText = feedbackText;
}

- (void)didClickCertificateButton {
    if (self.orderId) {
        return;
    }
    
    // need do nothing
}

- (void)didClickDeliverButton {
    if (self.orderId) {
        return;
    }
    
    if ((self.deliverType == DeliverType_KuaiDi) && !self.confirmOrderDC.enableZiti) {
        [Utilities showToastWithText:@"暂时不支持其它配送方式" withImageName:nil blockUI:NO];
        return;
    }
    if ((self.deliverType == DeliverType_ZiTi) && !self.confirmOrderDC.enableKuaidi) {
        [Utilities showToastWithText:@"暂时不支持其它配送方式" withImageName:nil blockUI:NO];
        return;
    }
    
    DeliverTypeVC *vc = [[DeliverTypeVC alloc] init];
    vc.priceArray = @[@(self.confirmOrderDC.kuaidiPrice), @(0)];
    vc.deliverType = self.deliverType;
    vc.delegate = self;
    [Utilities showPopupVC:vc];
}

- (void)didClickTicketButton {
    if (self.orderId) {
        return;
    }
    
    InvoiceVC *vc = [[InvoiceVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickPayTypeButton {
    if ((self.payType == PayType_WeChat) && ![self.confirmOrderDC.payTypeArray containsObject:@"alipay"]) {
        [Utilities showToastWithText:@"暂时不支持其它支付方式" withImageName:nil blockUI:NO];
        return;
    }
    if ((self.payType == PayType_AliPay) && ![self.confirmOrderDC.payTypeArray containsObject:@"weixin"]) {
        [Utilities showToastWithText:@"暂时不支持其它支付方式" withImageName:nil blockUI:NO];
        return;
    }
    
    PayTypeVC *vc = [[PayTypeVC alloc] init];
    vc.delegate = self;
    vc.payType = self.payType;
    [Utilities showPopupVC:vc];
}

#pragma mark - DeliverTypeVCDelegate 

- (void)didClickCancelButtonInDeliverTypeVC {
    [Utilities dismissPopup];
}

- (void)didClickConfirmButtonWithDeliverType:(DeliverType)deliverType price:(CGFloat)price {
    self.deliverType = deliverType;
    self.deliverPrice = price;
    
    [Utilities dismissPopup];
}

#pragma mark - PayTypeVCDelegate

- (void)didClickCancelButtonInPayTypeVC {
    [Utilities dismissPopup];
}

- (void)didClickConfirmButtonWithPayType:(PayType)payType {
    self.payType = payType;
    [Utilities dismissPopup];
}

#pragma mark - InvoiceVCDelegate

- (void)didChooseInvoiceType:(int)piaoType
                   piaoTitle:(NSString *)piaoTitle
                 piaoContent:(NSString *)piaoContent {
    self.piaoType = piaoType;
    self.piaoTitle = piaoTitle;
    self.piaoContent = piaoContent;
}

#pragma mark - PPDataControllerDelegate

- (void)loadingDataFinished:(PPDataController *)controller {
    if (controller == self.confirmOrderDC) {
        self.addressModel = self.confirmOrderDC.address;
        self.productItemsArray = [NSMutableArray arrayWithArray:self.confirmOrderDC.orderItemsArray];
        
        if (!self.confirmOrderDC.enableKuaidi && !self.confirmOrderDC.enableZiti) {
            [Utilities showToastWithText:@"数据有误，不支持任何配送方式" withImageName:nil blockUI:NO];
            self.deliverType = DeliverType_ZiTi;
            self.deliverPrice = 0;
        }
        
        if (self.confirmOrderDC.enableKuaidi) {
            self.deliverType = DeliverType_KuaiDi;
            self.deliverPrice = self.confirmOrderDC.kuaidiPrice;
        } else if (self.confirmOrderDC.enableZiti) {
            self.deliverType = DeliverType_ZiTi;
            self.deliverPrice = 0;
        }
        
        if ([self.confirmOrderDC.payTypeArray containsObject:@"wexin"]) {
            self.payType = PayType_WeChat;
        } else if ([self.confirmOrderDC.payTypeArray containsObject:@"alipay"]) {
            self.payType = PayType_AliPay;
        } else {
            [Utilities showToastWithText:@"数据有误，不支持任何配送方式" withImageName:nil blockUI:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        [[GCDQueue mainQueue] queueBlock:^{
            [self.tableView reloadData];
        }];
    } else if (controller == self.createOrderDC) {
        self.payResultDC.oid = self.createOrderDC.oid ? self.createOrderDC.oid : @"";
        
        if (self.payType == PayType_WeChat) {
            [self weixinPayWithDict:self.createOrderDC.weixinDict];
        } else if (self.payType == PayType_AliPay) {
            [self alipayWithOrderId:self.createOrderDC.outTradeNumberId
                               name:self.createOrderDC.subject
                        description:self.createOrderDC.body
                              money:self.createOrderDC.totalFee];
        }
    } else if (controller == self.repayDC) {
        self.payResultDC.oid = self.repayDC.orderNumberId ? self.repayDC.orderNumberId : @"";
        
        if (self.payType == PayType_WeChat) {
            [self weixinPayWithDict:self.repayDC.weixinDict];
        } else if (self.payType == PayType_AliPay) {
            [self alipayWithOrderId:self.repayDC.outTradeNumberId
                               name:self.repayDC.subject
                        description:self.repayDC.body
                              money:self.repayDC.totalFee];
        }
    } else if (controller == self.payResultDC) {
        if (self.payResultDC.responseCode == 200) {
            PaySuccessVC *successVC = [[PaySuccessVC alloc] init];
            
            successVC.receiverName = self.addressModel.recipientName;
            successVC.receiverPhoneNumber = self.addressModel.recipientPhoneNum;
            successVC.receiverAddress = self.addressModel.detailAddress;
            
            NSDate *payDate = [NSDate dateWithTimeIntervalSince1970:[self.payResultDC.paytime longLongValue]];
            NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[self.payResultDC.createtime longLongValue]];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            successVC.orderNumberString = self.payResultDC.orderNumberString;
            successVC.payDateString = [dateFormatter stringFromDate:payDate];
            successVC.createOrderDateString = [dateFormatter stringFromDate:createDate];
            
            [self.navigationController pushViewController:successVC animated:YES];
        } else {
            PayFailedVC *failedVC = [[PayFailedVC alloc] init];
            failedVC.delegate = self;
            [self.navigationController pushViewController:failedVC animated:YES];
        }
    } else if (controller == self.orderDetailDC) {
        [Utilities hideLoadingView];
        
        OrderDetailModel *orderDetailModel = self.orderDetailDC.orderDetailModel;
        
        NSMutableArray *modelArray = [NSMutableArray array];
        for (ProductListGoodsModel* item in orderDetailModel.orderProductListModel.productListGoodsArray) {
            OrderItemModel* submodel = [OrderItemModel new];
            submodel.productId = item.productID;
            submodel.productTitle = item.productTitle;
            submodel.productImageUrl = item.productImageUrl;
            submodel.descriptionString = item.productModel;
            submodel.productPrice = [item.productPrice floatValue];
            submodel.buyNum = [item.productNumber intValue];
            [modelArray addObject:submodel];
        }
        self.productItemsArray = modelArray;
        self.confirmOrderDC.productItemsArray = modelArray;
        self.createOrderDC.productItemsArray = modelArray;
        
        Address *addressModel = [[Address alloc] init];
        addressModel.recipientName = orderDetailModel.orderReceiverName;
        addressModel.recipientPhoneNum = orderDetailModel.orderReceiverPhone;
        addressModel.detailAddress = orderDetailModel.orderReceiverAddress;
        self.addressModel = addressModel;
        
        double goodsPriceToSet = 0;
        for (ProductListGoodsModel* goodItem in orderDetailModel.orderProductListModel.productListGoodsArray) {
            goodsPriceToSet += [goodItem.productPrice doubleValue] * [goodItem.productNumber intValue];
        }
        self.confirmOrderDC.goodsPrice = goodsPriceToSet;
        
        self.confirmOrderDC.kuaidiPrice = [orderDetailModel.orderProductListModel.productExpressPrice doubleValue];
        if ([orderDetailModel.pickUp intValue] == 0) {
            self.deliverType = DeliverType_KuaiDi;
            self.deliverPrice = self.confirmOrderDC.kuaidiPrice;
        } else {
            self.deliverType = DeliverType_ZiTi;
            self.deliverPrice = 0;
        }
        
        self.confirmOrderDC.payTypeArray = orderDetailModel.payTypeArray;
        
        if ([orderDetailModel.currentPay isEqualToString:@"weixin"] && [orderDetailModel.payTypeArray containsObject:@"weixin"]) {
            self.payType = PayType_WeChat;
        } else if ([orderDetailModel.currentPay isEqualToString:@"alipay"] && [orderDetailModel.payTypeArray containsObject:@"alipay"]) {
            self.payType = PayType_AliPay;
        } else if ([orderDetailModel.payTypeArray containsObject:@"weixin"]) {
            self.payType = PayType_WeChat;
        } else if ([orderDetailModel.payTypeArray containsObject:@"alipay"]) {
            self.payType = PayType_AliPay;
        } else {
            [Utilities showToastWithText:@"数据有误，不支持任何配送方式" withImageName:nil blockUI:NO];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        self.piaoType = orderDetailModel.piaoType;
        self.piaoTitle = orderDetailModel.piaoTitle;
        self.piaoContent = orderDetailModel.piaoContent;
        self.feedbackText = orderDetailModel.feedbackText;
        
        [self.tableView reloadData];
    } else if (controller == self.deleteOrderDC) {
        [self handleCreateOrderAction];
    }
}

- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error {
    if (controller == self.confirmOrderDC) {
        [Utilities showToastWithText:self.confirmOrderDC.responseMsg withImageName:nil blockUI:NO];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (controller == self.createOrderDC) {
        if (self.createOrderDC.responseMsg.length > 0) {
            [Utilities showToastWithText:self.createOrderDC.responseMsg withImageName:nil blockUI:NO];
        } else {
            [Utilities showToastWithText:@"生成订单失败" withImageName:nil blockUI:NO];
        }
    } else if (controller == self.repayDC) {
        if (self.repayDC.responseMsg.length > 0) {
            [Utilities showToastWithText:self.repayDC.responseMsg withImageName:nil blockUI:NO];
        } else {
            [Utilities showToastWithText:@"重新支付失败" withImageName:nil blockUI:NO];
        }
    } else if (controller == self.payResultDC) {
        if (self.payResultDC.responseMsg.length > 0) {
            [Utilities showToastWithText:self.payResultDC.responseMsg withImageName:nil blockUI:NO];
        } else {
            [Utilities showToastWithText:@"支付失败" withImageName:nil blockUI:NO];
        }
    } else if (controller == self.orderDetailDC) {
        [Utilities hideLoadingView];
        
        if (self.orderDetailDC.responseMsg.length > 0) {
            [Utilities showToastWithText:self.orderDetailDC.responseMsg withImageName:nil blockUI:NO];
        } else {
            [Utilities showToastWithText:@"获取订单信息失败" withImageName:nil blockUI:NO];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } else if (controller == self.deleteOrderDC) {
        
        NSLog (@"删除订单失败:%@", self.deleteOrderDC.responseMsg);
        
        [self handleCreateOrderAction];
    }
}

#pragma mark - PayFailedVCDelegate

- (void)didChangePayType:(PayType)payType {
    self.payType = payType;
}

- (void)didClickPayAgainButtonInPayFailedVC {
    [self.navigationController popViewControllerAnimated:YES];
    
    self.repayDC.oid = self.createOrderDC.oid;
    self.repayDC.payType = (self.payType == PayType_WeChat) ? @"weixin" : @"alipay";
    
    [self.repayDC requestWithArgs:nil];
}

@end
