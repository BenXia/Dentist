//
//  AddressListDC.m
//  Dentist
//
//  Created by 王涛 on 16/2/21.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "AddressListDC.h"
#import "Address.h"

@implementation AddressListDC
- (NSDictionary *)requestURLArgs {
    NSString* token = [UserCache sharedUserCache].token ? [UserCache sharedUserCache].token : @"";
    return @{@"method":@"address.mylist",@"v":@"0.0.1",@"auth":token};
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
        NSArray *addressArray = [resultdict objectForKey:@"address"];
        for (int i = 0; i<addressArray.count;i++) {
            Address *addressModel = [[Address alloc] init];
            addressModel.province = @"上海";
            addressModel.city = @"上海";
            addressModel.area = @"张江";
            addressModel.detailAddress = @"亮秀路112号浦东软件园";
            addressModel.recipientName = @"王涛";
            addressModel.recipientPhoneNum = @"15221323805";
            addressModel.postCode = @"123456";
            if (i == 0) {
                addressModel.isDefault = YES;
            }
            [self.addressArr addObject:addressModel];
        }
        result = YES;
    }
    
    return result;
}

- (NSMutableArray *)addressArr {
    if (!_addressArr) {
        _addressArr = [NSMutableArray array];
    }
    return _addressArr;
}

@end
