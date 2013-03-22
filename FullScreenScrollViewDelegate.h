//
//  FullScreenScrollViewDelegate.h
//  ModalGroupContacts
//
//  Created by marco on 13-3-12.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FullScreenScrollViewDelegate : NSObject<UIScrollViewDelegate>
{
    CGFloat _prevContentOffsetY;
    BOOL    _isScrollingTop;
    BOOL    _canMaskTable;
}
- (id)initWithAboveViewOnTable:(UIView*)headView belowViewOnTable:(UIView*)footView;
- (void)showHeaderViewWithScrollView:(UIScrollView*)scrollView animated:(BOOL)animated;
@property(nonatomic, assign)UIView* floatHeaderView;
@property(nonatomic, assign)UIView* floatFooterView;
@end
