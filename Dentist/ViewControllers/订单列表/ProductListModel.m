//
//  ProductListModel.m
//  Dentist
//
//  Created by Ben on 2/20/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "ProductListModel.h"

@implementation ProductListModel

- (id)init {
    if (self = [super init]) {
        self.productListGoodsArray = [NSMutableArray new];
    }
    return self;
}

@end
