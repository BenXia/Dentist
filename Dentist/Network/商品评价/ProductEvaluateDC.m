//
//  ProductEvaluateDC.m
//  Dentist
//
//  Created by Ben on 2/24/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "ProductEvaluateDC.h"
#import "ProductEvaluateModel.h"

@implementation ProductEvaluateDC

- (NSDictionary *)requestURLArgs {
    if (self.nextId != nil) {
        return @{@"method":@"item.score",@"v":@"0.0.1",@"iid":self.productId,@"next_iid":[NSNumber numberWithInt:self.nextId.intValue],@"pagesize":@"10"};
    } else {
        return @{@"method":@"item.score",@"v":@"0.0.1",@"iid":self.productId,@"pagesize":@"10"};
    }
}

- (RequestMethod)requestMethod {
    return RequestMethodGET;
}

-(NSDictionary*)requestHTTPBody{
    return nil;
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    
    NSLog(@"商品评论响应数据：%@",content);
    
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        self.nextId = [resultDict objectForKey:@"next_iid"];
        NSArray *scoreArray = [resultDict objectForKey:@"scores"];
        for (int index = 0; index < scoreArray.count; index++) {
            NSDictionary *dic = scoreArray[index];
            ProductEvaluateModel *model = [ProductEvaluateModel new];
            model.evaluateUserName = [dic objectForKey:@"nickname"];
            model.evaluateScore = [dic objectForKey:@"score"];
            model.evaluateContent = [dic objectForKey:@"content"];
            NSString *time = [dic objectForKey:@"addtime"];
            NSDate* createDate = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            model.evaluateTime = [dateFormatter stringFromDate:createDate];
            model.evaluateImageArray = [dic objectForKey:@"imgs"];
            [self.productEvaluateArray addObject:model];
        }
        result = YES;
    }
    return result;
}

- (NSMutableArray *)productEvaluateArray {
    if (_productEvaluateArray == nil) {
        _productEvaluateArray = [NSMutableArray new];
    }
    return _productEvaluateArray;
}
@end
