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
            NSDictionary *addressDict = addressArray[i];
            Address *addressModel = [[Address alloc] init];
            addressModel.province = [addressDict objectForKey:@"province_name"];
            addressModel.city = [addressDict objectForKey:@"city_name"];
            addressModel.area = [addressDict objectForKey:@"area_name"];
            addressModel.detailAddress = [addressDict objectForKey:@"address"];
            addressModel.recipientName = [addressDict objectForKey:@"name"];
            addressModel.recipientPhoneNum = [addressDict objectForKey:@"mobile"];
            addressModel.postCode = [addressDict objectForKey:@"zipcode"];
            addressModel.ID = [addressDict objectForKey:@"aid"];
            addressModel.isDefault = [[addressDict objectForKey:@"is_default"] isEqualToString:@"1"];;
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
