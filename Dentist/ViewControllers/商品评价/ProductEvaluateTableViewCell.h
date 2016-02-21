//
//  ProductEvaluateTableViewCell.h
//  Dentist
//
//  Created by Ben on 2/21/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductEvaluateModel;
@interface ProductEvaluateTableViewCell : UITableViewCell


+ (float)getCellHeightWithContent:(ProductEvaluateModel *)model;

- (void)setCellWithProductEvaluateModel:(ProductEvaluateModel *)model;

@end
