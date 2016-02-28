//
//  CreateOrEditAddressVC.m
//  Dentist
//
//  Created by Ben on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "CreateOrEditAddressVC.h"
#import "HZLocation.h"
#import "UPdataAddressDC.h"
#import "GetAddressRegionDC.h"

#define PickerViewHeight             250

@interface CreateOrEditAddressVC () <UITextFieldDelegate,PPDataControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *postCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *defaultAddressBtn;
@property (weak, nonatomic) IBOutlet UIView *selectCityView;

//城市选择
@property (strong, nonatomic) IBOutlet UIView *classTimePickerContentView;
@property (weak, nonatomic) IBOutlet UIView *pickerBackgroundView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerContentView;
@property (weak, nonatomic) IBOutlet UIButton *pickerCancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *pickerTitleBtn;
@property (weak, nonatomic) IBOutlet UIButton *pickerDonebtn;

@property (strong, nonatomic) NSArray *provinces;
@property (strong, nonatomic) NSArray *cities;
@property (strong, nonatomic) NSArray *areas;
@property (strong, nonatomic) HZLocation *locate;
@property (nonatomic) BOOL isDefault;

//网络请求
@property (strong, nonatomic) UPdataAddressDC *updataAddressRequest;
@property (strong, nonatomic) GetAddressRegionDC *getAddressRegionRequest;
@end

@implementation CreateOrEditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isDefault = YES;
    [self downloadfromNet];
    [self initUI];
    if (self.type == kAddressToChange) {
        [self refreshUI];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.classTimePickerContentView removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    self.tableView.tableHeaderView = self.tableHeaderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Action

- (IBAction)onDefaultAddressBtn:(UIButton *)sender {
    self.isDefault = !self.isDefault;
    if (self.isDefault) {
        [self.defaultAddressBtn setImage:[UIImage imageNamed:@"btn_choice_t"] forState:UIControlStateNormal];
    } else {
        [self.defaultAddressBtn setImage:[UIImage imageNamed:@"btn_choice_f"] forState:UIControlStateNormal];
    }
}

- (IBAction)onCancleBtn:(UIButton *)sender {
    [self hidePickerView];
}

- (IBAction)onSelectedBtn:(UIButton *)sender {
    self.areaTextField.text = [NSString stringWithFormat:@"%@ %@ %@",self.locate.state,self.locate.city,self.locate.district];
    [self hidePickerView];
}

- (void)onRightBarButtonItem {
    if (![self.phoneNumTextField.text isValidMobileNumber]) {
        [Utilities showToastWithText:@"请输入正确的电话号码"];
        return;
    }
    if (self.nameTextField.text.length == 0) {
        [Utilities showToastWithText:@"请输入昵称"];
        return;
    }
    if (self.areaTextField.text.length == 0) {
        [Utilities showToastWithText:@"请选择城市区域"];
        return;
    }
    if (self.detailAddressTextField.text.length == 0) {
        [Utilities showToastWithText:@"请输入详细地址"];
        return;
    }
    if (self.postCodeTextField.text.length == 0) {
        [Utilities showToastWithText:@"请输入邮政编码"];
        return;
    }
    //修改地址接口
    
    self.updataAddressRequest = [[UPdataAddressDC alloc] initWithDelegate:self];
    self.updataAddressRequest.recipientName = self.nameTextField.text;
    self.updataAddressRequest.province = self.locate.state;
    self.updataAddressRequest.city = self.locate.city;
    self.updataAddressRequest.area = self.locate.district;
    self.updataAddressRequest.addressString = self.detailAddressTextField.text;
    self.updataAddressRequest.mobile = self.phoneNumTextField.text;
    self.updataAddressRequest.zipcode = self.postCodeTextField.text;
    self.updataAddressRequest.is_default = self.isDefault;
    if (self.type == kAddressToChange) {
        self.updataAddressRequest.aid = self.addressModel.ID;
    }
    [self.updataAddressRequest requestWithArgs:nil];
}

#pragma mark - Private Method

- (void)initData {
    self.provinces = self.getAddressRegionRequest.provinceArray;
    self.cities = [[self.provinces objectAtIndex:0] objectForKey:@"c"];
    
    self.locate.state = [[self.provinces objectAtIndex:0] objectForKey:@"p"];
    self.locate.city = [[self.cities objectAtIndex:0] objectForKey:@"n"];
    
    self.areas = [[self.cities objectAtIndex:0] objectForKey:@"a"];
    if (self.areas.count > 0) {
        self.locate.district = [[self.areas objectAtIndex:0] objectForKey:@"s"];
    } else{
        self.locate.district = @"";
    }
    [self.pickerContentView reloadAllComponents];
    
}

- (void)initUI {
    self.classTimePickerContentView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.classTimePickerContentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.navigationController.view addSubview:self.classTimePickerContentView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePickerViewSingleTap:)];
    [self.classTimePickerContentView addGestureRecognizer:singleTap];
    
    [self.phoneNumTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.postCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPickerView)];
    [self.selectCityView addGestureRecognizer:tap];
    //
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onRightBarButtonItem)]];
    switch (self.type) {
        case kAddressToAdd: {
            self.title = @"新建收货地址";
        }
            break;
        case kAddressToChange: {
            self.title = @"修改收货地址";
        }
            break;
            
        default:
            break;
    }
    
    self.view.backgroundColor = [UIColor themeBackGrayColor];
    self.tableView.backgroundColor = [UIColor themeBackGrayColor];
    
    self.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = [UIView new];
}

- (void)refreshUI {
    self.nameTextField.text = self.addressModel.recipientName;
    self.phoneNumTextField.text = self.addressModel.recipientPhoneNum;
    self.areaTextField.text = [NSString stringWithFormat:@"%@%@%@",self.addressModel.province,self.addressModel.city,self.addressModel.area];
    self.detailAddressTextField.text = self.addressModel.detailAddress;
    self.postCodeTextField.text = self.addressModel.postCode;
    if (self.addressModel.isDefault) {
        [self.defaultAddressBtn setImage:[UIImage imageNamed:@"btn_choice_t"] forState:UIControlStateNormal];
    }
}

- (void)downloadfromNet {
    self.getAddressRegionRequest = [[GetAddressRegionDC alloc] initWithDelegate:self];
    [self.getAddressRegionRequest requestWithArgs:nil];
}

#pragma mark 手势处理

- (void)handlePickerViewSingleTap:(UITapGestureRecognizer *)tap {
    [self hidePickerView];
}

- (void)hidePickerView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.classTimePickerContentView.alpha = 0;
        self.pickerBackgroundView.frame = CGRectMake(0, self.classTimePickerContentView.frame.size.height, [UIScreen mainScreen].bounds.size.width, PickerViewHeight);
    }completion:^(BOOL finished) {
        self.classTimePickerContentView.hidden = YES;
    }];
}

- (void)showPickerView
{
    [self.nameTextField resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
    [self.detailAddressTextField resignFirstResponder];
    [self.postCodeTextField resignFirstResponder];
    self.classTimePickerContentView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.classTimePickerContentView.alpha = 1;
        self.pickerBackgroundView.frame = CGRectMake(0, self.classTimePickerContentView.frame.size.height - PickerViewHeight, [UIScreen mainScreen].bounds.size.width, PickerViewHeight);
    }];
}

#pragma mark pickerView相关方法

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

//每列对应多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [self.provinces count];
            break;
        case 1:
            return [self.cities count];
            break;
        case 2:
            return [self.areas count];
            break;
        default:
            return 0;
            break;
    }}

//每列每行对应显示的数据是什么
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[self.provinces objectAtIndex:row] objectForKey:@"p"];
            break;
        case 1:
            return [[self.cities objectAtIndex:row] objectForKey:@"n"];
            break;
        case 2:
            if ([self.areas count] > 0) {
                return [[self.areas objectAtIndex:row] objectForKey:@"s"];
                break;
            }
        default:
            return  @"";
            break;
    }
    
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

// 当选中了pickerView的某一行的时候调用
// 会将选中的列号和行号作为参数传入
// 只有通过手指选中某一行的时候才会调用
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            self.cities = [[self.provinces objectAtIndex:row] objectForKey:@"c"];
            [self.pickerContentView selectRow:0 inComponent:1 animated:YES];
            [self.pickerContentView reloadComponent:1];
            
            self.areas = [[self.cities objectAtIndex:0] objectForKey:@"a"];
            [self.pickerContentView selectRow:0 inComponent:2 animated:YES];
            [self.pickerContentView reloadComponent:2];
            
            self.locate.state = [[self.provinces objectAtIndex:row] objectForKey:@"p"];
            self.locate.city = [[self.cities objectAtIndex:0] objectForKey:@"n"];
            if ([self.areas count] > 0) {
                self.locate.district = [[self.areas objectAtIndex:0] objectForKey:@"s"];
            } else{
                self.locate.district = @"";
            }
            break;
        case 1:
            self.areas = [[self.cities objectAtIndex:row] objectForKey:@"a"];
            [self.pickerContentView selectRow:0 inComponent:2 animated:YES];
            [self.pickerContentView reloadComponent:2];
            
            self.locate.city = [[self.cities objectAtIndex:row] objectForKey:@"n"];
            if ([self.areas count] > 0) {
                self.locate.district = [[self.areas objectAtIndex:0] objectForKey:@"s"];
            } else{
                self.locate.district = @"";
            }
            break;
        case 2:
            if ([self.areas count] > 0) {
                self.locate.district = [[self.areas objectAtIndex:row] objectForKey:@"s"];
            } else{
                self.locate.district = @"";
            }
            break;
        default:
            break;
    }
}

//自定义piker字体
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:22]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

-(HZLocation *)locate
{
    if (_locate == nil) {
        _locate = [[HZLocation alloc] init];
    }
    
    return _locate;
}

#pragma mark - PPDataControllerDelegate

- (void)loadingData:(PPDataController *)controller failedWithError:(NSError *)error {
    if (controller == self.updataAddressRequest) {
        [Utilities showToastWithText:[NSString stringWithFormat:@"保存地址失败"]];
    } else if (controller == self.getAddressRegionRequest) {
        [Utilities showToastWithText:[NSString stringWithFormat:@"获取后台城市列表失败"]];
    }
}

- (void)loadingDataFinished:(PPDataController *)controller {
    if (controller == self.updataAddressRequest) {
        [[GCDQueue mainQueue] queueBlock:^{
            if (self.updataAddressRequest.responseCode == 200) {
                [Utilities showToastWithText:[NSString stringWithFormat:@"地址保存成功"]];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [Utilities showToastWithText:[NSString stringWithFormat:@"保存地址失败"]];
            }
            
        }];
    }else if (controller == self.getAddressRegionRequest) {
        [self initData];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.phoneNumTextField) {
        if (![textField.text isNumber]) {
            [Utilities showToastWithText:@"请输入数字"];
            return;
        }
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
        
    } else if (textField==self.postCodeTextField){
        
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
