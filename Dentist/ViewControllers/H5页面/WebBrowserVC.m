//
//  WebBrowserViewController.m
//  Dentist
//
//  Created by Ben on 15/8/1.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "WebBrowserVC.h"

@interface WebBrowserVC () <PPEasyWebViewControllerDelegate>

@property (nonatomic, strong) PPEasyWebViewController *easyWebViewController;
@property (nonatomic, strong) NSString *linkTitle;
@property (nonatomic, strong) NSURL *linkURL;
@property (weak, nonatomic) IBOutlet UIView *bottomActivityView;

@property (nonatomic, strong) IBOutlet UIButton *refreshButton;
@property (nonatomic, strong) IBOutlet UIButton *nextPageButton;
@property (nonatomic, strong) IBOutlet UIButton *previousPageButton;
@property (nonatomic, strong) UIControl *backgroundControl;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingStatusView;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;

@end

@implementation WebBrowserVC

@synthesize linkTitle = _linkTitle;
@synthesize linkURL = _linkURL;
@synthesize loadingStatusView = _loadingStatusView;

#pragma mark - Initializers

- (id)initWithLinkTitle:(NSString *)linkTitle linkURL:(NSURL *)linkURL {
    self = [super init];
    if (self) {
        self.linkTitle = linkTitle;
        self.linkURL = linkURL;
    }
    
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setNavTitleString:self.linkTitle];
    if (!self.easyWebViewController) {
        self.easyWebViewController = [[PPEasyWebViewController alloc] init];
        self.easyWebViewController.delegate = self;
        [self addChildViewController:self.easyWebViewController];
        [self.view insertSubview:self.easyWebViewController.view belowSubview:self.bottomActivityView];
        [self.easyWebViewController didMoveToParentViewController:self];
        self.bottomBar.alpha = 0.95;
        self.bottomBar.backgroundColor = [g_commonConfig themeBlueColor];
        self.easyWebViewController.easyJSWebView.scrollView.clipsToBounds = NO;
    }

    self.easyWebViewController.easyJSWebView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
    [self.easyWebViewController.easyJSWebView loadRequest:[NSURLRequest requestWithURL:self.linkURL]];
    self.bottomActivityView.hidden = NO;
    [self.loadingStatusView startAnimating];
    if ([self.easyWebViewController.easyJSWebView respondsToSelector:@selector(setMediaPlaybackRequiresUserAction:)]) {
        self.easyWebViewController.easyJSWebView.mediaPlaybackRequiresUserAction = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (UIInterfaceOrientationPortrait == interfaceOrientation);
}

#pragma mark - IBActions

- (IBAction)refreshBtnTapped:(id)sender {
    [self.easyWebViewController.easyJSWebView reload];
}

- (IBAction)nextPageBtnTapped:(id)sender {
    [self.easyWebViewController.easyJSWebView goForward];
}

- (IBAction)previousPageBtnTapped:(id)sender {
    [self.easyWebViewController.easyJSWebView goBack];
}

#pragma mark - UIWebViewDelegate

- (void)PPEasyWebViewStart {
    self.bottomActivityView.hidden = NO;
    [self.loadingStatusView startAnimating];

    self.previousPageButton.enabled = [self.easyWebViewController.easyJSWebView canGoBack];
    self.nextPageButton.enabled = [self.easyWebViewController.easyJSWebView canGoForward];
}

- (void)PPEasyWebViewFinish:(NSDictionary *)dic {
    if ([self.linkTitle length] == 0) {
        NSString *title = [self.easyWebViewController.easyJSWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if ([title length] > 0) {
            [self setNavTitleString:title];
        }
    }

    self.previousPageButton.enabled = [self.easyWebViewController.easyJSWebView canGoBack];
    self.nextPageButton.enabled = [self.easyWebViewController.easyJSWebView canGoForward];

    [self.loadingStatusView stopAnimating];
    self.bottomActivityView.hidden = YES;
}

- (void)PPEasyWebViewFail:(NSError *)error {
    self.previousPageButton.enabled = [self.easyWebViewController.easyJSWebView canGoBack];
    self.nextPageButton.enabled = [self.easyWebViewController.easyJSWebView canGoForward];
    
    [self.loadingStatusView stopAnimating];
    self.bottomActivityView.hidden = YES;
}

@end
