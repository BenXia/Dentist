//
//  AddressListVC.h
//  Dentist
//
//  Created by 王涛 on 16/2/21.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressListVC : BaseViewController

@property (nonatomic) BOOL isSelectAddress;
@property (nonatomic, strong) ObjectBlock selectedCompleteBlock;

@end
