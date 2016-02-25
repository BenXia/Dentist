//
//  ProductBriefInfoCell.h
//  Dentist
//
//  Created by Ben on 16/2/2.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShoppingCartModel;

@protocol ProductBriefInfoCellDelegate <NSObject>

//点击了加按钮
- (void)didClickedOnPlusButtonWithShoppingCartModel:(ShoppingCartModel *)shoppingCartModel;
//点击了减按钮
- (void)didClickedOnReduceButtonWithShoppingCartModel:(ShoppingCartModel *)shoppingCartModel;
//点击了完成按钮
- (void)didClickedOnDoneButtonWithShoppingCartModel:(ShoppingCartModel *)shoppingCartModel;
//点击了勾选按钮
- (void)didClickedOnSelectButtonWithShoppingCartModel:(ShoppingCartModel *)shoppingCartModel;
//点击了删除按钮
- (void)didClickedOnDeleteButtonWithShoppingCartModel:(ShoppingCartModel *)shoppingCartModel;
//点击了编辑按钮
- (void)didClickedOnEditButtonWithShoppingCartModel:(ShoppingCartModel *)shoppingCartModel;

@end


@interface ProductBriefInfoCell : UITableViewCell

@property (nonatomic, weak) id<ProductBriefInfoCellDelegate> delegate;           

- (void)setCellWithShoppingCartModel:(ShoppingCartModel *)shoppingCartModel;

- (void)setCellToEditType;
- (void)setCellToNormalType;

- (void)setCellToSelectType;
- (void)setCellToUnSelectType;

- (void)hideDeleteAndFinishButton;
- (void)showDeleteAndFinishButton;

@end
