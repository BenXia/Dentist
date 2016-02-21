//
//  AddressListDC.m
//  Dentist
//
//  Created by 王涛 on 16/2/21.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "AddressListDC.h"

@implementation AddressListDC
- (NSDictionary *)requestURLArgs {
    return @{@"method":@"address.mylist",@"v":@"0.0.1",@"auth":[UserCache sharedUserCache].token};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

- (NSDictionary *)requestHTTPBody {
    return nil;
}

- (BOOL)parseContent:(NSString *)content {
    
    BOOL result = NO;
    NSError *error = nil;
    NSDictionary *resultdict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultdict isKindOfClass:[NSDictionary class]]) {
        
        result = YES;
    }
    
    return result;
}


@end
