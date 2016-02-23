//
//  FeedbackVC.m
//  Dentist
//
//  Created by Ben on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "FeedbackVC.h"
#import "FeedbackCell.h"

static NSString* const kCellReuseIdentifier = @"FeedbackCell";

@interface FeedbackVC () <
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FeedbackVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUIRelated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)initUIRelated {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // NavigationBar
    [self setNavTitleString:@"评价晒单"];
    [self setNavLeftItemWithName:@"取消" target:self action:@selector(didClickOnLeftNavButtonAction:)];
    [self setNavRightItemWithName:@"发布" target:self action:@selector(didClickOnRightNavButtonAction:)];
    
    // TableView
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedbackCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kCellReuseIdentifier];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FeedbackCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - IBActions

- (void)didClickOnLeftNavButtonAction:(id)sender {
    
}

- (void)didClickOnRightNavButtonAction:(id)sender {
    
}

@end
