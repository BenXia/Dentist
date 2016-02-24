//
//  FeedbackModel.h
//  Dentist
//
//  Created by Ben on 16/2/23.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedbackModel : NSObject

@property (nonatomic, assign) NSInteger starNumber;
@property (nonatomic, strong) NSString *feedBackText;
@property (nonatomic, strong) NSMutableArray *imagesArray;

@end
