//
//  PPPayResultDC.m
//  Dentist
//
//  Created by Ben on 16/2/26.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PPPayResultDC.h"

@implementation PPPayResultDC

- (NSDictionary *)requestURLArgs {
    return @{@"method":@"order.pay_reslut", @"v":@"0.0.1", @"auth":[UserCache sharedUserCache].token, @"oid":self.oid};
}

- (RequestMethod)requestMethod {
    return RequestMethodGET;
}

- (void)requestWillStart {
    [super requestWillStart];
    
    self.responseMsg = @"";
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
        
        if (self.responseCode != 200) {
            return NO;
        }
        
        NSDictionary *orderDict = [resultdict objectForKey:@"order"];
        self.orderNumberString = [orderDict objectForKey:@"oid"];
        self.paytime = [orderDict objectForKey:@"paytime"];
        self.createtime = [orderDict objectForKey:@"createtime"];
        self.name = [orderDict objectForKey:@"name"];
        self.province_name = [orderDict objectForKey:@"province_name"];
        self.city_name = [orderDict objectForKey:@"city_name"];
        self.area_name = [orderDict objectForKey:@"area_name"];
        self.address = [orderDict objectForKey:@"address"];
        self.mobile = [orderDict objectForKey:@"mobile"];
        self.zipcode = [orderDict objectForKey:@"zipcode"];
        self.pay = [orderDict objectForKey:@"pay"];
        
        result = YES;
    }
    
    return result;
}

@end
