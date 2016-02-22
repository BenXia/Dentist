//
//  GuessYouLikeProductView.h
//  Dentist
//
//  Created by 郭晓倩 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuessYouLikeProductViewDelegate;
@interface GuessYouLikeProductView : UIView

@property (weak,nonatomic) id<GuessYouLikeProductViewDelegate> delegate;
@property (strong,nonatomic) UIImageView* imageView;
@property (strong,nonatomic) UILabel* priceLabel;
@property (strong,nonatomic) UILabel* titleLabel;

@property (strong,nonatomic) id model;

@end


@protocol GuessYouLikeProductViewDelegate <NSObject>

-(void)guessYouLikeProductView:(GuessYouLikeProductView*)view didClickProduct:(id)model;

@end