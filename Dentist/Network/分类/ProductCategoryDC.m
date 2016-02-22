//
//  ProductCategoryDC.m
//  Dentist
//
//  Created by 王涛 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "ProductCategoryDC.h"
#import "ProductCategoryModel.h"

@implementation ProductCategoryDC
- (NSDictionary *)requestURLArgs {
    return @{@"method":@"item.category",@"v":@"0.0.1"};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

- (NSDictionary *)requestHTTPBody {
    if (!self.md5) {
        return nil;
    }
    return @{@"md5":self.md5};
}

- (BOOL)parseContent:(NSString *)content {
    
    BOOL result = NO;
    NSError *error = nil;
    NSDictionary *resultdict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultdict isKindOfClass:[NSDictionary class]]) {
        self.responseCode = [[resultdict objectForKey:@"code"] intValue];
        if (self.responseCode == 200) {
            [[UserCache sharedUserCache] setMd5:[resultdict objectForKey:@"md5"]] ;
            for (NSDictionary *tempDict in [resultdict objectForKey:@"categorys"]) {
                ProductCategoryModel *model = [[ProductCategoryModel alloc] init];
                model.cid = [tempDict objectForKey:@"cid"];
                model.name = [tempDict objectForKey:@"name"];
                model.orderby = [tempDict objectForKey:@"orderby"];
                model.subCategoryArray = [NSMutableArray array];
                for (NSDictionary *subDict in [tempDict objectForKey:@"sub"]) {
                    ProductCategoryModel *subModel = [[ProductCategoryModel alloc] init];
                    subModel.cid = [subDict objectForKey:@"cid"];
                    subModel.name = [subDict objectForKey:@"name"];
                    subModel.orderby = [subDict objectForKey:@"orderby"];
                    subModel.image_url = [subDict objectForKey:@"img_url"];
                    [model.subCategoryArray addObject:subModel];
                }
                [self.productCategoryArray addObject:model];
                
            }
        }
        result = YES;
    }
    
    return result;
}

- (NSMutableArray *)productCategoryArray {
    if (!_productCategoryArray) {
        _productCategoryArray = [NSMutableArray array];
    }
    return _productCategoryArray;
}

@end
