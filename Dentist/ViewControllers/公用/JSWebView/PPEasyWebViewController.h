//
//  PPEasyWebViewController.h
//  Dentist
//
//  Created by Ben on 15/8/1.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "EasyJSDataFunction.h"
@protocol  PPEasyWebViewControllerDelegate <NSObject>

@optional
-(void) PPEasyWebViewStart;
-(void) PPEasyWebViewFinish:(NSDictionary *)dic;
-(void) PPEasyWebViewFail:(NSError *)error;

@end


@interface PPEasyWebViewController : UIViewController

@property (nonatomic, strong , readonly) EasyJSWebView* easyJSWebView;
@property (nonatomic ,weak) id<PPEasyWebViewControllerDelegate> delegate;

@end

