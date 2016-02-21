//
//  ProductEvaluateVC.m
//  Dentist
//
//  Created by Ben on 2/21/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "ProductEvaluateVC.h"
#import "ProductEvaluateTableViewCell.h"
#import "ProductEvaluateVM.h"
#import "ProductEvaluateModel.h"

@interface ProductEvaluateVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  ProductEvaluateVM *productEvaluateVM;

@end

@implementation ProductEvaluateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    
    self.productEvaluateVM.productEvaluateArray = [NSMutableArray new];
    
    ProductEvaluateModel *model = [ProductEvaluateModel new];
    model.evaluateUserName = @"大宝贝";
    model.evaluateScore = @"2";
    model.evaluateContent = @"小时飞机啊死哦发生大件破旧哦破发点过分手多久哦破哈佛圣诞节哦叫粉丝骄傲放假哦见佛扫地方见佛啊圣诞节佛";
    model.evaluateTime = @"2015-05-06 12:25:36";
    model.evaluateImageArray = [NSMutableArray arrayWithObjects:@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2", nil];

    
    
    ProductEvaluateModel *model1 = [ProductEvaluateModel new];
    model1.evaluateUserName = @"老婆";
    model1.evaluateScore = @"4";
    model1.evaluateContent = @"小时飞机啊死哦发生大件破旧哦破发点过分手多久哦破哈小时飞机啊死哦发生大件破旧哦破发点过分手多久哦破哈佛圣诞节哦叫粉丝骄傲放佛圣诞小时飞机啊死哦发生大件破旧哦破发点过分手多久哦破哈佛圣诞节哦叫粉丝骄傲放节哦叫粉丝骄傲放假哦见佛扫地方见佛啊圣诞节佛";
    model1.evaluateTime = @"2015-05-06 12:25:36";
    model1.evaluateImageArray = [NSMutableArray arrayWithObjects:@"2",@"2", nil];

    [self.productEvaluateVM.productEvaluateArray addObject:model];
    [self.productEvaluateVM.productEvaluateArray addObject:model1];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initUI {
    self.title = @"评价";
    self.view.backgroundColor = [UIColor backGroundGrayColor];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.productEvaluateVM.productEvaluateArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ProductEvaluateTableViewCell getCellHeightWithContent:[self.productEvaluateVM.productEvaluateArray objectAtIndexIfIndexInBounds:indexPath.section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"ProductEvaluateTableViewCell";
    ProductEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductEvaluateTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    ProductEvaluateModel *model = [self.productEvaluateVM.productEvaluateArray objectAtIndex:indexPath.section];
    [cell setCellWithProductEvaluateModel:model];
    return cell;
}

#pragma mark - Data Init

- (ProductEvaluateVM *)productEvaluateVM {
    if (_productEvaluateVM == nil) {
        _productEvaluateVM = [ProductEvaluateVM new];
    }
    return _productEvaluateVM;
}

@end
