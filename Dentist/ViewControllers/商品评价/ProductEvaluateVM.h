//
//  ProductEvaluateVM.h
//  Dentist
//
//  Created by Ben on 2/21/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductEvaluateDC.h"

@interface ProductEvaluateVM : NSObject

@property (strong, nonatomic)  ProductEvaluateDC *productEvaluateDC;
@property (strong, nonatomic)  NSString *productId;

@end
