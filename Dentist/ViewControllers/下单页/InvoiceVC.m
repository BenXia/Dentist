//
//  InvoiceVC.m
//  Dentist
//
//  Created by Ben on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "InvoiceVC.h"

@interface InvoiceVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

@property (weak, nonatomic) IBOutlet UIButton *ordinaryInvoiceButton;
@property (weak, nonatomic) IBOutlet UIButton *needNoInvoiceButton;
@property (weak, nonatomic) IBOutlet UIButton *taxInvoiceButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *invoiceTypeButtonsArray;

@property (weak, nonatomic) IBOutlet UITextField *invoiceHeaderTextField;

@property (weak, nonatomic) IBOutlet UIButton *detailChoiceButton;
@property (weak, nonatomic) IBOutlet UIButton *medicalChoiceButon;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *contentChoiceButtonsArray;

@end

@implementation InvoiceVC

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
    
    self.view.backgroundColor = [UIColor themeBackGrayColor];
    self.tableView.backgroundColor = [UIColor themeBackGrayColor];
    self.tableHeaderView.backgroundColor = [UIColor themeBackGrayColor];
    self.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = [UIView new];
    
    [self setNavTitleString:@"发票信息"];
    [self setNavRightItemWithName:@"保存" target:self action:@selector(didClickSaveNavButtonAction:)];
    
    for (UIButton *btn in self.invoiceTypeButtonsArray) {
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor themeCyanColor]] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:RGB(230, 230, 230)] forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor gray007Color] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [btn circularCorner];
        btn.layer.borderColor = RGB(230, 230, 230).CGColor;
        btn.layer.borderWidth = 1;
    }
    
    self.needNoInvoiceButton.selected = YES;
    self.needNoInvoiceButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.needNoInvoiceButton.layer.borderWidth = 0;
    self.taxInvoiceButton.enabled = NO;
    
//    [self.invoiceHeaderTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

//#pragma mark - UITextField Related
//
//- (void)textFieldDidChange:(UITextField *)textField {
//    if (textField == self.invoiceHeaderTextField) {
//    }
//}

#pragma mark - IBActions

- (void)didClickSaveNavButtonAction:(id)sender {
    if (!self.needNoInvoiceButton.selected && !self.ordinaryInvoiceButton.selected) {
        [Utilities showToastWithText:@"请先选择发票类型" withImageName:nil blockUI:NO];
        return;
    }
    
    if (self.ordinaryInvoiceButton.selected) {
        if (self.invoiceHeaderTextField.text.length == 0) {
            [Utilities showToastWithText:@"请填写发票标题" withImageName:nil blockUI:NO];
            return;
        }
        
        if (!self.detailChoiceButton.selected && !self.medicalChoiceButon.selected) {
            [Utilities showToastWithText:@"请选择发票内容" withImageName:nil blockUI:NO];
            return;
        }
    }

    [self.invoiceHeaderTextField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(didChooseInvoiceType:piaoTitle:piaoContent:)]) {
        int piaoType = 0;
        NSString *piaoContent = @"";
        
        if (self.needNoInvoiceButton.selected) {
            piaoType = 0;
        } else if (self.ordinaryInvoiceButton.selected) {
            piaoType = 1;
        }
        
        if (self.detailChoiceButton.selected) {
            piaoContent = @"明细";
        } else if (self.medicalChoiceButon.selected) {
            piaoContent = @"医疗用品";
        } else {
            piaoContent = @"";
        }
        
        [self.delegate didChooseInvoiceType:piaoType
                                  piaoTitle:self.invoiceHeaderTextField.text
                                piaoContent:piaoContent];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickInvoiceTypeButtonAction:(UIButton *)sender {
    for (UIButton *btn in self.invoiceTypeButtonsArray) {
        btn.selected = NO;
        btn.layer.borderColor = RGB(230, 230, 230).CGColor;
        btn.layer.borderWidth = 1;
    }
    
    sender.selected = YES;
    sender.layer.borderColor = [UIColor clearColor].CGColor;
    sender.layer.borderWidth = 0;
}

- (IBAction)didClickInvoiceContentChoiceButtonAction:(UIButton *)sender {
    for (UIButton *btn in self.contentChoiceButtonsArray) {
        btn.selected = NO;
    }
    
    sender.selected = YES;
}

@end
