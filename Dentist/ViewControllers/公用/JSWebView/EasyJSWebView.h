//
//  EasyJSWebView.h
//  EasyJS
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyJSWebViewProxyDelegate.h"

@interface EasyJSWebView : UIWebView

- (void) initEasyJS;

- (void) addJavascriptInterfaces:(NSObject*) interface WithName:(NSString*) name;

@end
