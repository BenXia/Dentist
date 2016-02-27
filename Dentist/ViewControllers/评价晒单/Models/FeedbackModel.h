//
//  FeedbackModel.h
//  Dentist
//
//  Created by Ben on 16/2/23.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductListGoodsModel.h"

@interface FeedbackModel : NSObject

@property (nonatomic, strong) ProductListGoodsModel* product;
@property (nonatomic, strong) NSNumber* starNumber;
@property (nonatomic, strong) NSString *feedBackText;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *imageUrls;

@end
