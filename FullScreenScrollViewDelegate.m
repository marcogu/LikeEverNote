//
//  FullScreenScrollViewDelegate.m
//  ModalGroupContacts
//
//  Created by marco on 13-3-12.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "FullScreenScrollViewDelegate.h"
#import "UIView+YIFullScreenScroll.h"

#import "ICRecipientPicker.h"

@implementation FullScreenScrollViewDelegate

-(id)initWithAboveViewOnTable:(UIView*)headView belowViewOnTable:(UIView*)footView{
    self = [super init];
    if (self) {
        self.floatHeaderView = headView;
        self.floatFooterView = footView;
    }
    return self;
}

- (void)layoutWithScrollView:(UIScrollView*)scrollView deltaY:(CGFloat)deltaY{
    BOOL topViewExisting = _floatHeaderView && _floatHeaderView.superview && !_floatHeaderView.hidden;
    if (topViewExisting) {
        if ((_floatHeaderView.top == scrollView.top && deltaY<0) ||
            (_floatHeaderView.bottom < scrollView.top && deltaY > 0)) {
            return;
        }
        float top = _floatHeaderView.top;
        top += -deltaY;
        if (top > scrollView.top) {
            top = scrollView.top;
        }
        if (top + _floatHeaderView.height < scrollView.top) {
            top = scrollView.top - _floatHeaderView.height;
        }
        _floatHeaderView.top = top;
    }
}

-(BOOL)validateMaskExcutable{
    ICRecipientPicker* pickerHead = (ICRecipientPicker*)self.floatHeaderView;
    _canMaskTable = [pickerHead.datasource numberOfItemsInPikcerView:pickerHead] > 0;
    return _canMaskTable;
}

#pragma mark - public

- (void)showHeaderViewWithScrollView:(UIScrollView*)scrollView animated:(BOOL)animated{
    if (scrollView.contentInset.top < _floatHeaderView.height) {
        void (^animateContent)(void) = ^(void) {
            [self layoutWithScrollView:scrollView deltaY:-_floatHeaderView.height];
            scrollView.contentInset = UIEdgeInsetsMake(_floatHeaderView.top, 0, 0, 0);
        };
        animated ? [UIView animateWithDuration:0.2 animations:animateContent] : animateContent();
    }
}

#pragma mark - delgate method

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if([self validateMaskExcutable])
        _prevContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ((scrollView.dragging || _isScrollingTop) && _canMaskTable)  {
        CGFloat deltaY = scrollView.contentOffset.y-_prevContentOffsetY;
        _prevContentOffsetY = MAX(scrollView.contentOffset.y, -scrollView.contentInset.top);
        [self layoutWithScrollView:scrollView deltaY:deltaY];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_canMaskTable) {
        [UIView beginAnimations:nil context:nil];
        scrollView.contentInset = UIEdgeInsetsMake(_floatHeaderView.top, 0, 0, 0);
        [UIView commitAnimations];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    _isScrollingTop = YES;
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    _isScrollingTop = NO;
}

@end
