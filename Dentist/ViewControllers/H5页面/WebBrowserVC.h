//
//  WebBrowserVC.h
//  Dentist
//
//  Created by Ben on 15/8/1.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPEasyWebViewController.h"

@interface WebBrowserVC : BaseViewController

// linkTitle显示在标题栏上，如果为空显示去网页的标题。
- (id)initWithLinkTitle:(NSString *)linkTitle linkURL:(NSURL *)linkURL;

@end
