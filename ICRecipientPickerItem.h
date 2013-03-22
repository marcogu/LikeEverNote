//
//  ICRecipientPickerItem.h
//  ModalGroupContacts
//
//  Created by marco on 13-3-16.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICRecipientPickerItem;

@protocol ICRecipientPickerItemDelegate <NSObject>
-(void)selectedPickerItem:(ICRecipientPickerItem *)item;
@end

@interface ICRecipientPickerItem : UIView
{
    UIColor* _unselectedBGColor;
    UIColor* _selectedBGColor;
    UIColor* _unselectedBorderColor;
    UIColor* _selectedBorderColor;
    UIColor* _unselectedTextColor;
    UIColor* _selectedTextColor;
@private
    BOOL _isSelected;
    CGPoint _touchBegan;
}
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) UILabel* textLabel;
@property (nonatomic, assign) NSObject<ICRecipientPickerItemDelegate>* delegate;
@property (nonatomic, retain) id object;
@property (nonatomic, assign) BOOL highlightTouches;
@property (nonatomic, assign) CGFloat pickerTextLabelPadding;

-(void)setSelected:(BOOL)selected animated:(BOOL)animated;
@end
