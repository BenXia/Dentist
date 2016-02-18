//
//  ChangeUserHeadImageDC.m
//  Dentist
//
//  Created by 王涛 on 16/2/18.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "ChangeUserHeadImageDC.h"

@implementation ChangeUserHeadImageDC
- (NSDictionary *)requestURLArgs {
    return @{@"method":@"user.set_avator",@"v":@"0.0.1"};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

- (NSDictionary *)requestHTTPBody {
    if (!self.headImage) {
        return nil;
    }
    
    return @{@"_FILES" : self.headImage};
}

- (BOOL)parseContent:(NSString *)content {
    
    BOOL result = NO;
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        self.responseCode = [[resultDict objectForKey:@"code"] intValue];
        self.responseMsg = [resultDict objectForKey:@"msg"];
        result = YES;
    }
    
    return result;
}

- (void)changeHeadImage:(UIImage *)image {
    //AFNetWorking 图片上传
}
@end
