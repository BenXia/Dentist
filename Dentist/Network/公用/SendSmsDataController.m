//
//  SendSmsDataController.m
//  Dentist
//
//  Created by Ben on 5/25/15.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "SendSmsDataController.h"
#import "NSJSONSerialization+Shortcuts.h"

@implementation SendSmsDataController

- (NSDictionary *)requestURLArgs {
    return @{@"method":@"user.getcode"};
}

- (RequestMethod)requestMethod {
    return RequestMethodPOST;
}

- (NSDictionary *)requestHTTPBody {
    if (!self.phoneNumber) {
        return nil;
    }
    
    return @{@"mobile" : self.phoneNumber};
}

- (BOOL)parseContent:(NSString *)content {
    BOOL result = NO;
    
    NSError *error = nil;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithString:content
                                                                 options:0
                                                                   error:&error];
    if (!error || [resultDict isKindOfClass:[NSDictionary class]]) {
        self.responseCode = [[resultDict objectForKey:@"code"] intValue];
        
        result = YES;
    }
    
    return result;
}

@end
