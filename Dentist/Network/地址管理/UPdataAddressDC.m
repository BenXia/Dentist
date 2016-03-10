//
//  UPdataAddressDC.m
//  Dentist
//
//  Created by 王涛 on 16/2/21.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "UPdataAddressDC.h"

@implementation UPdataAddressDC
- (NSDictionary *)requestURLArgs {
    return @{@"method":@"address.modified",@"v":@"0.0.1",@"auth":[UserCache sharedUserCache].token};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

- (NSDictionary *)requestHTTPBody {
    if (!self.province || !self.city || !self.area || !self.addressString || !self.mobile || !self.zipcode) {
        return nil;
    }
    if (self.aid) {
        return @{@"name":self.recipientName, @"p":self.province,@"n":self.city,@"c":self.area,@"address":self.addressString,@"mobile":self.mobile,@"zipcode":self.zipcode,@"is_delault":self.is_default ? @"1" : @"0" ,@"aid":self.aid};
    } else {
        return @{@"name":self.recipientName,@"p":self.province,@"n":self.city,@"c":self.area,@"address":self.addressString,@"mobile":self.mobile,@"zipcode":self.zipcode,@"is_delault":self.is_default ? @"1" : @"0" };
    }
}

- (BOOL)parseContent:(NSString *)content {
    
    BOOL result = NO;
    NSError *error = nil;
    NSDictionary *resultdict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultdict isKindOfClass:[NSDictionary class]]) {
        self.responseCode = [[resultdict objectForKey:@"code"] intValue];
        self.responseMsg = [resultdict objectForKey:@"msg"];
        result = YES;
    }
    
    return result;
}

@end
