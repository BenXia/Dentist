//
//  FavoriteProductCell.h
//  Dentist
//
//  Created by 郭晓倩 on 16/2/22.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteProductCell : UICollectionViewCell

-(void)setModel:(id)model isEditing:(BOOL)isEditing isSelected:(BOOL)isSelected;

@end
