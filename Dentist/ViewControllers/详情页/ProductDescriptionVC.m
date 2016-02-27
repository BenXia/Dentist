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

- (NSString*)preferNavBackButtonTitle{
    return @"商品详情";
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didClickOnBackButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate


@end
