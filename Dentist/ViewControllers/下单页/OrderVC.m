//
//  OrderVC.m
//  Dentist
//
//  Created by Ben on 16/2/15.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "OrderVC.h"
#import "OrderVM.h"
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
#import "PPPayResultDC.h"
#import "PPRepayDC.h"
#import "PaySuccessVC.h"
#import "PayFailedVC.h"
#import "WeXinMD5Encrypt.h"
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

@property (nonatomic, strong) PPConfirmOrderDC *confirmOrderDC;
@property (nonatomic, strong) PPCreateOrderDC *createOrderDC;
@property (nonatomic, strong) PPPayResultDC *payResultDC;
@property (nonatomic, strong) PPRepayDC *repayDC;

@property (nonatomic, strong) OrderVM *vm;

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
        
        self.payResultDC = [[PPPayResultDC alloc] init];
        self.payResultDC.delegate = self;
        
        self.repayDC = [[PPRepayDC alloc] init];
        self.repayDC.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUIReleated];
    
    [self bindViewModel];
    
    [self.confirmOrderDC requestWithArgs:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter methods

- (void)setProductItemsArray:(NSMutableArray *)productItemsArray {
    self.vm.productItemsArray = productItemsArray;
    
    self.confirmOrderDC.productItemsArray = productItemsArray;
    self.createOrderDC.productItemsArray = productItemsArray;
}

- (void)setGroupId:(NSString *)groupIds {
    self.confirmOrderDC.groupIds = groupIds;
    self.createOrderDC.groupIds = groupIds;
}

- (void)setPayType:(PayType)payType {
    _payType = payType;
    
    [self.tableView reloadData];
}

- (void)setDeliverType:(DeliverType)deliverType {
    _deliverType = deliverType;
    
    [self.tableView reloadData];
}

- (void)setDeliverPrice:(double)deliverPrice {
    _deliverPrice = deliverPrice;
    
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

- (OrderVM *)vm {
    if (!_vm) {
        _vm = [[OrderVM alloc] init];
    }
    
    return _vm;
}

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

- (void)bindViewModel {
    //    @weakify(self);
    //
    //    // 对智康家长隐藏科目入口
    //    [[[RACObserve([StudentInfoModel sharedInstance], isFromZhiKang) distinctUntilChanged] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNumber* x) {
    //        @strongify(self);
    //        [self.tableView reloadData];
    //        [self refreshHeaderCourseListView];
    //
    //        if ([StudentInfoModel sharedInstance].isLoggedin && [StudentInfoModel sharedInstance].isFromZhiKang) {
    //            self.tableView.contentOffset = CGPointZero;
    //            self.tableView.scrollEnabled = NO;
    //        } else {
    //            self.tableView.scrollEnabled = YES;
    //        }
    //    }];
    //
    //    // 监听登录状态(对智康家长隐藏科目入口)
    //    [[[RACObserve([StudentInfoModel sharedInstance], isLoggedin) distinctUntilChanged] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
    //        @strongify(self);
    //        [self.tableView reloadData];
    //        [self refreshHeaderCourseListView];
    //
    //        if ([StudentInfoModel sharedInstance].isLoggedin && [StudentInfoModel sharedInstance].isFromZhiKang) {
    //            self.tableView.contentOffset = CGPointZero;
    //            self.tableView.scrollEnabled = NO;
    //        } else {
    //            self.tableView.scrollEnabled = YES;
    //        }
    //    }];
    //
    //    // 刷新城市信息
    //    [[RACObserve([StudentInfoModel sharedInstance], cityId) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNumber* cityId) {
    //        @strongify(self);
    //        if (cityId) {
    //            self.selectedCity = [[CityCache sharedCityCache] objectForId:cityId];
    //            self.cityNameLabel.text = self.selectedCity.cityName;
    //
    //            [self.bannerVM.cmd_getHomePageBanners execute:cityId];
    //
    //            [self.homePageVM.cmd_getPromotedTeacherArray execute:cityId];
    //        }
    //    }];
    //
    //    // 未登录成功时，使用定位城市
    //    if (![StudentInfoModel sharedInstance].isLoggedin) {
    //        [[LocationService sharedInstance] currentLocationWithBlock:^(LocationModel *location) {
    //            //用户手动选择了城市后，不再使用定位信息
    //            if ([StudentInfoModel sharedInstance].cityId) {
    //                return ;
    //            }
    //            //定位失败会强制选择城市
    //            NSString *cityName=[[UserCityService sharedUserCityService] getUserCityName];
    //            if (cityName) {
    //                [StudentInfoModel sharedInstance].cityId = [[CityCache sharedCityCache] idForname:cityName];
    //            } else if (location) {
    //                [StudentInfoModel sharedInstance].cityId =  @(location.cityID);
    //                [StudentInfoModel saveCityIdToCache:@(location.cityID)];
    //            } else {
    //                [self didClickSelectCity];
    //            }
    //        }];
    //    }
    //
    //    // Banner广告
    //    RACCommand* cmd_getHomePageBanners = self.bannerVM.cmd_getHomePageBanners;
    //    [cmd_getHomePageBanners.executionSignals subscribeNext:^(RACSignal* x) {
    //        [[x deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
    //            @strongify(self);
    //            [self refreshBanner];
    //        }];
    //    }];
    //
    //    // 名师风采列表
    //    [self.homePageVM.cmd_getPromotedTeacherArray.executionSignals subscribeNext:^(RACSignal* x) {
    //        [[x deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
    //            @strongify(self);
    //            [self.tableView reloadData];
    //        }];
    //    }];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vm.productItemsArray.count + 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        OrderReceiverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderReceiverCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.receiverNameLabel.text = self.vm.addressModel.recipientName ? self.vm.addressModel.recipientName : @"收件人姓名";
        cell.receiverPhoneNumberLabel.text = self.vm.addressModel.recipientPhoneNum ? self.vm.addressModel.recipientPhoneNum : @"收件人电话";
        cell.receiverAddressLabel.text = self.vm.addressModel.detailAddress ? self.vm.addressModel.detailAddress : @"收件人地址";
        
        return cell;
    } else if (indexPath.row == 1) {
        OrderItemHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderItemHeaderCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == self.vm.productItemsArray.count + 2) {
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
    } else if (indexPath.row == self.vm.productItemsArray.count + 3) {
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
        
        return cell;
    } else {
        OrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderItemCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        OrderItemModel *model = [self.vm.productItemsArray objectAtIndex:indexPath.row - 2];
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
        return [OrderReceiverCell heightWithAddress:self.vm.addressModel.detailAddress ? self.vm.addressModel.detailAddress : @"收件人地址"];
    } else if (indexPath.row == 1) {
        return 50;
    } else if (indexPath.row == self.vm.productItemsArray.count + 2) {
        return 40;
    } else if (indexPath.row == self.vm.productItemsArray.count + 3) {
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
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        AddressListVC *vc = [[AddressListVC alloc] init];
        vc.isSelectAddress = YES;
        vc.selectedCompleteBlock = ^(Address *address) {
            self.vm.addressModel = address;
            
            [[GCDQueue mainQueue] queueBlock:^{
                [self.tableView reloadData];
            }];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - IBActions

- (IBAction)didClickPayNowButtonAction:(id)sender {
    if (self.vm.addressModel.ID.length == 0) {
        [Utilities showToastWithText:@"请先填写收件地址" withImageName:nil blockUI:NO];
        return;
    }
    
    self.createOrderDC.orderExpress = (self.deliverType == DeliverType_KuaiDi) ? @"express" : @"pick_up";
    self.createOrderDC.aid = self.vm.addressModel.ID;
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
    // need do nothing
}

- (void)didClickDeliverButton {
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
        self.vm.addressModel = self.confirmOrderDC.address;
        self.vm.productItemsArray = [NSMutableArray arrayWithArray:self.confirmOrderDC.orderItemsArray];
        
        if (!self.confirmOrderDC.enableKuaidi && !self.confirmOrderDC.enableZiti) {
            [Utilities showToastWithText:@"数据有误，不支持任何配送方式" withImageName:nil blockUI:NO];
        }
        
        if (self.confirmOrderDC.enableKuaidi) {
            self.deliverType = DeliverType_KuaiDi;
            self.deliverPrice = self.confirmOrderDC.kuaidiPrice;
        } else if (self.confirmOrderDC.enableZiti) {
            self.deliverType = DeliverType_ZiTi;
            self.deliverType = 0;
        }
        
        if ([self.confirmOrderDC.payTypeArray containsObject:@"wexin"]) {
            self.payType = PayType_WeChat;
        } else if ([self.confirmOrderDC.payTypeArray containsObject:@"alipay"]) {
            self.payType = PayType_AliPay;
        }
        
        [[GCDQueue mainQueue] queueBlock:^{
            [self.tableView reloadData];
        }];
    } else if (controller == self.createOrderDC) {
        self.payResultDC.oid = self.createOrderDC.oid ? self.createOrderDC.oid : @"";
        
        if (self.payType == PayType_WeChat) {
            // TODO-Ben:微信支付
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
            
            config.appId                    = [self.createOrderDC.weixinDict objectForKey:@"appid"];
            config.partnerId                = [self.createOrderDC.weixinDict objectForKey:@"mch_id"];
            order.package                   = @"Sign=WXPay";
            order.nonceStr                  = [self.createOrderDC.weixinDict objectForKey:@"nonce_str"];
            order.prepayId                  = [self.createOrderDC.weixinDict objectForKey:@"prepay_id"];
//            order.sign                      = [self.createOrderDC.weixinDict objectForKey:@"sign"];;
            
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            UInt32 timeStamp =[timeSp intValue];
            order.timeStamp = timeStamp;
            
            WeXinMD5Encrypt *md5Generator = [[WeXinMD5Encrypt alloc] init];
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
                @strongify(self)
                
                [self.payResultDC requestWithArgs:nil];
            };
            [wechatpay pay];
        } else if (self.payType == PayType_AliPay) {
            // TODO-WT:支付宝支付
            ComponentAlipay_Order *order = [[ComponentAlipay_Order alloc] init];
            order.ID = self.createOrderDC.oid;
            order.name = [self.createOrderDC.alipayDict objectForKey:@"name"];
            order.desc = [self.createOrderDC.alipayDict objectForKey:@"desc"];
            order.price = self.createOrderDC.money;
            [[AlipayManager sharedAlipayManager] payWithAlipay:order completeBlock:^(NSDictionary *dic) {
                [[GCDQueue mainQueue] queueBlock:^{
                    [self alipayResult:dic];
                }];
            }];
            
        }
    } else if (controller == self.repayDC) {
        self.payResultDC.oid = self.repayDC.orderNumberId ? self.repayDC.orderNumberId : @"";
        
        if (self.payType == PayType_WeChat) {
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
            
            config.appId                    = [self.repayDC.weixinDict objectForKey:@"appid"];
            config.partnerId                = [self.repayDC.weixinDict objectForKey:@"mch_id"];
            order.package                   = @"Sign=WXPay";
            order.nonceStr                  = [self.repayDC.weixinDict objectForKey:@"nonce_str"];
            order.prepayId                  = [self.repayDC.weixinDict objectForKey:@"prepay_id"];
            //            order.sign                      = [self.repayDC.weixinDict objectForKey:@"sign"];;
            
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            UInt32 timeStamp =[timeSp intValue];
            order.timeStamp = timeStamp;
            
            WeXinMD5Encrypt *md5Generator = [[WeXinMD5Encrypt alloc] init];
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
                @strongify(self)
                
                [self.payResultDC requestWithArgs:nil];
            };
            [wechatpay pay];
        } else if (self.payType == PayType_AliPay) {
            // TODO-WT:支付宝支付
            
            [self.payResultDC requestWithArgs:nil];
        }
    } else if (controller == self.payResultDC) {
        if (self.payResultDC.responseCode == 200) {
            PaySuccessVC *successVC = [[PaySuccessVC alloc] init];
            
            successVC.receiverName = self.vm.addressModel.recipientName;
            successVC.receiverPhoneNumber = self.vm.addressModel.recipientPhoneNum;
            successVC.receiverAddress = self.vm.addressModel.detailAddress;
            
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
    }
}

- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error {
    if (controller == self.confirmOrderDC) {
        @weakify(self);
        [[GCDQueue mainQueue] queueBlock:^{
            @strongify(self);
            [Utilities showToastWithText:@"确认订单失败" withImageName:nil blockUI:NO];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else if (controller == self.createOrderDC) {
        [Utilities showToastWithText:@"生成订单失败" withImageName:nil blockUI:NO];
    } else if (controller == self.repayDC) {
        [Utilities showToastWithText:@"重新支付失败" withImageName:nil blockUI:NO];
    } else if (controller == self.payResultDC) {
        [Utilities showToastWithText:@"支付失败" withImageName:nil blockUI:NO];
    }
}

#pragma mark - PayFailedVCDelegate

- (void)didChangePayType:(PayType)payType {
    self.payType = payType;
}

- (void)didClickPayAgainButtonInPayFailedVC {
    [self.navigationController popViewControllerAnimated:YES];
    
    // 方案一：
    //[self didClickPayNowButtonAction:nil];
    
    // 方案二：
    self.repayDC.oid = self.createOrderDC.oid;
    self.repayDC.payType = (self.payType == PayType_WeChat) ? @"weixin" : @"alipay";
    
    [self.repayDC requestWithArgs:nil];
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
            self.aliPayErrorDesc = @"支付宝 支付订单取消";
        }
            break;
            
        case kAlipayErrorCode_NetError: {
            self.aliPayErrorDesc = @"网络连接失败";
        }
            
        default: {
            self.aliPayErrorDesc = @"unknown";
        }
            break;
    }
    
    [Utilities showToastWithText:self.aliPayErrorDesc];
}

@end
