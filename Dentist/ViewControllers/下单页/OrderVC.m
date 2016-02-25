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
#import "FeedbackVC.h"

@interface OrderVC () <
UITableViewDataSource,
UITableViewDelegate,
OrderBottomInfoCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;

@property (nonatomic, strong) OrderVM *vm;

@end

@implementation OrderVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUIReleated];
    
    self.vm.productItemsArray = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", nil];
    [self bindViewModel];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        return 220;
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
        
        // TODO-Ben:选择地址
    }
}

#pragma mark - OrderBottomInfoCellDelegate

- (void)didClickCertificateButton {
    
}

- (void)didClickDeliverButton {
    
}

- (void)didClickTicketButton {
    
}

- (void)didClickPayTypeButton {
    
}

@end
