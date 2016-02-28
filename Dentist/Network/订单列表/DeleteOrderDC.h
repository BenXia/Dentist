//
//  DeleteOrderDC.h
//  Dentist
//
//  Created by Ben on 2/26/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import "PPDataController.h"

@interface DeleteOrderDC : PPDataController

@property(nonatomic, strong) NSString *oid;

// output
@property (nonatomic, assign) int responseCode;
@property (nonatomic, strong) NSString *responseMsg;

@end
