//
//  ICRecipientPicker.h
//  ModalGroupContacts
//
//  Created by marco on 13-3-16.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ICRecipientPickerItem.h"

typedef enum
{
    ICRecipientPickerSelectionStyleDefault,
    ICRecipientPickerSelectionStyleNone
}ICRecipientPickerSelectionStyle;

@protocol ICRecipientPickerDataSource;
@protocol ICPickerViewDelegate;

@interface ICRecipientPicker : UIScrollView<ICRecipientPickerItemDelegate>
{
    NSMutableArray* _items;
    UIMenuController* _menu;
}
@property (nonatomic, assign) NSObject<ICRecipientPickerDataSource>* datasource;
@property (nonatomic, assign) NSObject<ICPickerViewDelegate>* pickViewDelegate;
@property (nonatomic, assign) CGFloat itemPadding;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) ICRecipientPickerItem* activeItem;
@property (nonatomic, assign) ICRecipientPickerSelectionStyle selectionStyle;

-(void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated;
-(void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated;
@end

@protocol ICRecipientPickerDataSource <NSObject>
-(NSInteger)numberOfItemsInPikcerView:(ICRecipientPicker *)pickerView;
-(ICRecipientPickerItem *)recipientPicker:(ICRecipientPicker*)pickerView itemForIndex:(NSInteger)index;
-(void)putItem:(NSObject*)item;
@end

@protocol ICPickerViewDelegate<NSObject>
@optional
-(void)pickerView:(ICRecipientPicker*)view didSelectPickerItemAtIndex:(NSInteger)index;
-(BOOL)pickerView:(ICRecipientPicker*)view shouldShowMenuForPickerItemAtIndex:(NSInteger)idx;
-(NSArray*)pickerView:(ICRecipientPicker*)view menuItemsForPickerItemAtIndex:(NSInteger)index;
-(void)pickerView:(ICRecipientPicker*)view didHideMenuForPickerItemAtIndex:(NSInteger)index;
@end