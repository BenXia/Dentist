//
//  GroupProductView.h
//  Dentist
//
//  Created by 郭晓倩 on 16/2/20.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GroupProductViewDelegate;
@interface GroupProductView : UIView

@property (weak,nonatomic) id<GroupProductViewDelegate> delegate;
@property (strong,nonatomic) UIImageView* imageView;
@property (strong,nonatomic) UILabel* priceLabel;
@property (strong,nonatomic) UILabel* titleLabel;

@property (assign,nonatomic) BOOL selected;

@end

@protocol GroupProductViewDelegate <NSObject>

-(void)groupProductView:(GroupProductView*)view didClickImageView:(UIImageView*)imageView;

@end