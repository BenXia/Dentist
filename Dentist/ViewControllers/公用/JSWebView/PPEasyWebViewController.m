//
//  PPEasyWebViewController.m
//  Dentist
//
//  Created by Ben on 15/8/1.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPEasyWebViewController.h"
#import "PPJSExternal.h"
#import "AppDelegate.h"

@interface PPEasyWebViewController () <PPJSExternalDelegate, UIWebViewDelegate>

@property (nonatomic, strong) EasyJSWebView* easyJSWebView;

@end

@implementation PPEasyWebViewController

#pragma mark - View Life Cycle

- (id)init
{
    self = [super init];
    if (self) {
        self.easyJSWebView = nil;
    }
    return self;
}

- (void)loadView
{
    self.easyJSWebView = [[EasyJSWebView alloc] init];
    self.easyJSWebView.scalesPageToFit = YES;
    self.easyJSWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.easyJSWebView.delegate = self;
    PPJSExternal* interface = [PPJSExternal new];
    interface.delegate = self;
    [self.easyJSWebView addJavascriptInterfaces:interface WithName:@"external"];
    self.view =self.easyJSWebView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.delegate = nil;
    self.easyJSWebView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - PPJSExternalDelegate

- (void)PPJSExternalFinish:(NSDictionary *)dic
{
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([self.delegate respondsToSelector:@selector(PPEasyWebViewStart)]) {
        [self.delegate performSelector:@selector(PPEasyWebViewStart) withObject:nil];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self.delegate respondsToSelector:@selector(PPEasyWebViewFinish:)]) {
        [self.delegate performSelector:@selector(PPEasyWebViewFinish:) withObject:nil];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(PPEasyWebViewFail:)]) {
        [self.delegate performSelector:@selector(PPEasyWebViewFail:) withObject:nil];
    }
}

@end
