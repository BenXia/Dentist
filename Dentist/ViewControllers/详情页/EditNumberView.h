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

@property (weak,nonatomic) id<EditNumberViewDelegate> delegate;

-(void)resetWithMin:(NSNumber*)min max:(NSNumber*)max default:(NSNumber*)def;

@end

@protocol EditNumberViewDelegate <NSObject>

-(void)editNumberView:(EditNumberView*)view didMinusNum:(int)num;
-(void)editNumberView:(EditNumberView*)view didAddNum:(int)num;

@end
