//
//  ProductDescriptionVC.m
//  Dentist
//
//  Created by 郭晓倩 on 16/2/21.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "ProductDescriptionVC.h"

@interface ProductDescriptionVC () <UIWebViewDelegate>

@property (strong,nonatomic) NSString* htmlString;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ProductDescriptionVC

- (instancetype)initWithHtmlString:(NSString *)html{
    if (self = [super init]) {
        self.htmlString = html;
        self.title = @"图文详情";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [backButton setTitle:@"商品详情" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backButton setTitleColor:[UIColor whiteColor]];
    [backButton setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didClickOnReturn) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    NSLog(@"图文详情HTML：%@",self.htmlString);
    
    [self.webView loadHTMLString:self.htmlString baseURL:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIColor*)preferNavBarBackgroundColor{
    return [UIColor themeBlueColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UI Action

-(void)didClickOnReturn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate


@end
