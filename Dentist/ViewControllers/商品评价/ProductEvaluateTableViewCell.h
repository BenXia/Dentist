//
//  ProductEvaluateTableViewCell.h
//  Dentist
//
//  Created by Ben on 2/21/16.
//  Copyright © 2016 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductEvaluateModel;

@protocol ProductEvaluateTableViewCellDelegate <NSObject>

@optional
- (void)setStatusBarHidden:(BOOL)statusBarHidden;

@end

@interface ProductEvaluateTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ProductEvaluateTableViewCellDelegate> delegate;

+ (float)getCellHeightWithContent:(ProductEvaluateModel *)model;

- (void)setCellWithProductEvaluateModel:(ProductEvaluateModel *)model;

- (void)setTopLineViewHidden:(BOOL)hidden;

@end
