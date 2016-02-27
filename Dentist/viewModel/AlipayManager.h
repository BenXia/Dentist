//
//  AlipayManager.h
//  Dentist
//
//  Created by 王涛 on 16/2/27.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComponentAlipay_Order.h"

@interface AlipayManager : NSObject

+ (AlipayManager *)sharedAlipayManager;
- (void)payWithAlipay:(ComponentAlipay_Order *)order completeBlock:(DictionaryBlock) completeBlock;
@end
