//
//  ProductEvaluateModel.h
//  Dentist
//
//  Created by Ben on 2/21/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductEvaluateModel : NSObject

@property (nonatomic, strong) NSString *evaluateUserName;          //评价者
@property (nonatomic, strong) NSString *evaluateScore;             //评价级别
@property (nonatomic, strong) NSString *evaluateContent;           //评价类容
@property (nonatomic, strong) NSString *evaluateTime;              //评价时间
@property (nonatomic, strong) NSArray  *evaluateImageArray;        //评价图片

@end
