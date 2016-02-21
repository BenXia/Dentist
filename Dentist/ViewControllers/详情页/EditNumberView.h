//
//  EditNumberView.h
//  Dentist
//
//  Created by 郭晓倩 on 16/2/20.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditNumberViewDelegate;
@interface EditNumberView : UIView

@property (strong,nonatomic) NSNumber* max; //上限，不设表示无上限
@property (strong,nonatomic) NSNumber* min; //下限，不设表示无下限
@property (assign,nonatomic) int num;       //当前值

@property (weak,nonatomic) id<EditNumberViewDelegate> delegate;

@end

@protocol EditNumberViewDelegate <NSObject>

-(void)editNumberView:(EditNumberView*)view didChangeNum:(int)num;

@end
