//
//  InvoiceVC.h
//  Dentist
//
//  Created by Ben on 16/2/17.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InvoiceVCDelegate;

@interface InvoiceVC : BaseViewController

@property (nonatomic, weak) id<InvoiceVCDelegate> delegate;

@end

@protocol InvoiceVCDelegate <NSObject>

@optional
- (void)didChooseInvoiceType:(int)piaoType
                   piaoTitle:(NSString *)piaoTitle
                 piaoContent:(NSString *)piaoContent;

@end
