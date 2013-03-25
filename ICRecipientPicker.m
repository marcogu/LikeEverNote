//
//  ICRecipientPicker.m
//  ModalGroupContacts
//
//  Created by marco on 13-3-16.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ICRecipientPicker.h"

#define ITEM_ANIMATION_TIME 0.2
#define ITEM_FADE_TIME 0.2

#define TTDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface ICRecipientPicker()
{
    CGFloat nextItemX;
    CGFloat nextItemY;
    NSInteger lineNumber;
    NSInteger olderLineNo;
    UIMenuController* menu;
}
-(void)removeItem:(ICRecipientPickerItem *)item animated:(BOOL)animated;
@end

@implementation ICRecipientPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemHeight = 20.0;
        self.itemPadding = 10;
        _items = [[NSMutableArray alloc] init];
        self.selectionStyle = ICRecipientPickerSelectionStyleDefault;
    }
    return self;
}

-(void)dealloc{
    [_items release];
    [super dealloc];
}

-(void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated{
    ICRecipientPickerItem* item = [_items objectAtIndex:index];
    [_items removeObject:item];
    [self removeItem:item animated:animated];
}

-(void)removeItem:(ICRecipientPickerItem *)item animated:(BOOL)animated
{
    [item removeFromSuperview];
    [_items enumerateObjectsUsingBlock:^(id pickItem, NSUInteger idx, BOOL *stop) {
        ((ICRecipientPickerItem*)pickItem).index = idx;
    }];
    [self renderItemsAnimated:animated];
}

-(void)renderItemsAnimated:(BOOL)animated{
    [self renderItemsFromIndex:0 toIndex:[_items count] animated:animated];
}

-(void)renderItemsFromIndex:(NSInteger)start toIndex:(NSInteger)end animated:(BOOL)animated{
    nextItemY = nextItemX = _itemPadding;
    lineNumber = 1;
    
    [_items enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(start, end-start)] options:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ICRecipientPickerItem* pickItem = obj;
        [pickItem setSelected:NO animated:animated];
        if (_selectionStyle == ICRecipientPickerSelectionStyleNone)
            pickItem.highlightTouches = NO;
        CGFloat itemWidth = [pickItem.textLabel.text sizeWithFont:pickItem.textLabel.font
                constrainedToSize:CGSizeMake(100000, _itemHeight)].width+2*pickItem.pickerTextLabelPadding;
        if (itemWidth >= self.frame.size.width-2 * _itemPadding) {
            itemWidth = self.frame.size.width-2 * _itemPadding;
            nextItemX = _itemPadding;
            nextItemY += (lineNumber == 1 ? 0 : (_itemHeight + _itemPadding));
            lineNumber++;
        }else if ((nextItemX + itemWidth) > self.frame.size.width - 2 * _itemPadding){
            lineNumber++;
            nextItemX = _itemPadding;
            nextItemY += (lineNumber == 1 ? 0 : _itemHeight + _itemPadding);
        }
        CGRect itemFrame = CGRectMake(nextItemX, nextItemY, itemWidth, _itemHeight);
        if (animated) {
            [UIView beginAnimations:@"pickerRendering" context:@"pickerItems"];
            [UIView setAnimationDuration:ITEM_ANIMATION_TIME];
            pickItem.frame = itemFrame;
            [UIView commitAnimations];
        }else{
            pickItem.frame = itemFrame;
        }
        nextItemX += pickItem.frame.size.width + _itemPadding;
    }];
    
    if (lineNumber != olderLineNo) {
        olderLineNo = lineNumber;
        self.contentSize = CGSizeMake(self.frame.size.width, lineNumber * (_itemHeight + _itemPadding) + _itemPadding);
        float deltaH = self.contentSize.height - self.frame.size.height;
        [self scrollRectToVisible:CGRectMake(0, deltaH, self.contentSize.width, self.contentSize.height) animated:YES];
    }
}

-(void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated{
    index = [self validateIdx:index];
    ICRecipientPickerItem* pickItem = [self.datasource recipientPicker:self itemForIndex:index];
    [_items insertObject:pickItem atIndex:index];
    pickItem.delegate = self;
    pickItem.frame = CGRectZero;
    [self addSubview:pickItem];
    pickItem.alpha = 0.0;
    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ((ICRecipientPickerItem*)pickItem).index = idx;
    }];
    if (animated && [_items lastObject] == pickItem) {
        [self renderItemsFromIndex:0 toIndex:_items.count animated:NO];
        [self fadeInItem:pickItem];
    } else if(animated) { // not last item
        [self renderItemsFromIndex:0 toIndex:_items.count animated:YES];
        [self performSelector:@selector(fadeInItem:) withObject:pickItem afterDelay:ITEM_ANIMATION_TIME+ITEM_FADE_TIME];
    }else {
        [self renderItemsFromIndex:0 toIndex:_items.count animated:animated];
        pickItem.alpha = 1.0;
    }
}

-(void)scrollToButtomWithAnimation:(BOOL)animation{
    float deltaH = self.contentSize.height - self.frame.size.height;
    if (deltaH > 0 ) {
        CGRect bottomRect = CGRectMake(0, deltaH, self.contentSize.width, self.frame.size.height);
        [self scrollRectToVisible:bottomRect animated:animation];
    }
}

-(NSInteger)validateIdx:(NSInteger)idx{
    return idx < 0 || idx > _items.count ? _items.count : idx;
}

-(void)fadeInItem:(ICRecipientPickerItem *)item{
    [UIView beginAnimations:@"pickerFadeIn" context:@"pickerFade"];
    item.alpha = 1.0;
    [UIView commitAnimations];
}


-(void)selectedPickerItem:(ICRecipientPickerItem *)item{
    if (item != _activeItem) {
        switch (_selectionStyle) {
            case ICRecipientPickerSelectionStyleDefault:
                [item setSelected:YES animated:YES];
                break;
            case ICRecipientPickerSelectionStyleNone:
                [item setSelected:NO animated:NO];
                break;
            default:
                break;
        }
    }
    if ([_pickViewDelegate respondsToSelector:@selector(pickerView:didSelectPickerItemAtIndex:)])
        [_pickViewDelegate pickerView:self didSelectPickerItemAtIndex:item.index];
    if ([_pickViewDelegate respondsToSelector:@selector(pickerView:shouldShowMenuForPickerItemAtIndex:)] &&
                [_pickViewDelegate pickerView:self shouldShowMenuForPickerItemAtIndex:item.index]) {
            NSArray* menuItems = [_pickViewDelegate pickerView:self menuItemsForPickerItemAtIndex:item.index];
            [self showMenuCalloutWthItems:menuItems forPickerItem:item];
    }
}

-(void)showMenuCalloutWthItems:(NSArray *)menuItems forPickerItem:(ICRecipientPickerItem*)item{
    [self becomeFirstResponder];
    _activeItem = item;
    menu = [UIMenuController sharedMenuController];
    menu.menuItems = nil;
    menu.menuItems = menuItems;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowMenuController) name:UIMenuControllerWillShowMenuNotification object:menu];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideMenuController) name:UIMenuControllerDidHideMenuNotification object:menu];
    [menu setTargetRect:item.frame inView:self];
    [menu setMenuVisible:YES animated:YES];
}

-(void)willShowMenuController{
    self.userInteractionEnabled = NO;
}

-(void)didHideMenuController{
    [self resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    menu = [UIMenuController sharedMenuController];
    menu.menuItems = nil;
    
    self.userInteractionEnabled = YES;
    [_activeItem setSelected:NO animated:YES];
    if ([self.pickViewDelegate respondsToSelector:@selector(pickerView:didHideMenuForPickerItemAtIndex:)])
        [self.pickViewDelegate pickerView:self didHideMenuForPickerItemAtIndex:_activeItem.index];
    _activeItem = nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([menu isMenuVisible]) {
        [menu setMenuVisible:NO animated:YES];
    }
    menu = nil;
}
@end