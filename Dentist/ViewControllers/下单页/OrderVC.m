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

@interface OrderVC () <
UITableViewDataSource,
UITableViewDelegate,
OrderBottomInfoCellDelegate,
DeliverTypeVCDelegate,
PayTypeVCDelegate,
PPDataControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;

@property (nonatomic, strong) PPConfirmOrderDC *confirmOrderDC;
@property (nonatomic, strong) PPCreateOrderDC *createOrderDC;

@property (nonatomic, strong) OrderVM *vm;

@end

@implementation OrderVC

#pragma mark - View life cycle

- (instancetype)init {
    if (self = [super init]) {
        self.confirmOrderDC = [[PPConfirmOrderDC alloc] init];
        self.confirmOrderDC.delegate = self;
        
        self.createOrderDC = [[PPCreateOrderDC alloc] init];
        self.createOrderDC.delegate = self;
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
        return cell;
    } else if (indexPath.row == self.vm.productItemsArray.count + 3) {
        OrderBottomInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderBottomInfoCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
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
        return 70;
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
    self.createOrderDC.orderExpress = @"pick_up";
    self.createOrderDC.aid = self.vm.addressModel.ID;
    self.createOrderDC.payType = @"weixin";//@"alipay";
    self.createOrderDC.orderCertArray = @[];
    self.createOrderDC.piaoType = @"0";
    self.createOrderDC.piaoTitle = @"携程在手，说走就走";
    self.createOrderDC.piaoContent = @"发票明细是什么";
    self.createOrderDC.remarkNum = @"备注是什么";
    
    [self.createOrderDC requestWithArgs:nil];
    
//    @property (nonatomic, strong) NSString *orderExpress;
//    @property (nonatomic, strong) NSString *aid;
//    @property (nonatomic, strong) NSString *payType;
//    
//    // 非必选字段
//    @property (nonatomic, strong) NSArray *orderCertArray;
//    @property (nonatomic, strong) NSString *piaoType;
//    @property (nonatomic, strong) NSString *piaoTitle;
//    @property (nonatomic, strong) NSString *piaoContent;
//    @property (nonatomic, strong) NSString *remarkNum;
}

#pragma mark - OrderBottomInfoCellDelegate

- (void)didClickCertificateButton {
    
}

- (void)didClickDeliverButton {
    DeliverTypeVC *vc = [[DeliverTypeVC alloc] init];
    vc.priceArray = @[@(10.0), @(10.0), @(0)];
    vc.delegate = self;
    [Utilities showPopupVC:vc];
}

- (void)didClickTicketButton {
    InvoiceVC *vc = [[InvoiceVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickPayTypeButton {
    PayTypeVC *vc = [[PayTypeVC alloc] init];
    vc.delegate = self;
    [Utilities showPopupVC:vc];
}

#pragma mark - DeliverTypeVCDelegate 

- (void)didClickCancelButtonInDeliverTypeVC {
    [Utilities dismissPopup];
}

- (void)didClickConfirmButtonWithDeliverType:(DeliverType)deliverType price:(CGFloat)price {
    NSLog (@"deliverType: %zd price: %f", deliverType, price);
    [Utilities dismissPopup];
}

#pragma mark - PayTypeVCDelegate

- (void)didClickCancelButtonInPayTypeVC {
    [Utilities dismissPopup];
}

- (void)didClickConfirmButtonWithPayType:(PayType)payType {
    NSLog (@"payType: %zd", payType);
    [Utilities dismissPopup];
}

#pragma mark - PPDataControllerDelegate

- (void)loadingDataFinished:(PPDataController *)controller {
    if (controller == self.confirmOrderDC) {
        self.vm.addressModel = self.confirmOrderDC.address;
        self.vm.productItemsArray = [NSMutableArray arrayWithArray:self.confirmOrderDC.orderItemsArray];
        
        [[GCDQueue mainQueue] queueBlock:^{
            [self.tableView reloadData];
        }];
    } else if (controller == self.createOrderDC) {
        
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
    }
}

@end
