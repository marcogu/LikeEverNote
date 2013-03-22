//
//  ICRecipientPickerItem.m
//  ModalGroupContacts
//
//  Created by marco on 13-3-16.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ICRecipientPickerItem.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_BG_COLOR UIColorFromRGB(222,231,248,255)
#define DEFAULT_SELECTED_BG_COLOR UIColorFromRGB(89,137,236,255)

#define DEFAULT_TEXT_COLOR UIColorFromRGB(0,0,0,255)
#define DEFAULT_SELECTED_TEXT_COLOR UIColorFromRGB(255,255,255,255)

#define DEFAUL_BORDER_COLOR UIColorFromRGB(109,149,224,255)
#define DEFAULT_SELECTED_BORDER_COLOR UIColorFromRGB(109,149,224,255)

#define ITEM_TEXTLABELPADDING_LEFT_AND_RIGHT 10.0;

UIColor* UIColorFromRGB(NSInteger red, NSInteger green, NSInteger blue, NSInteger alpha) {
    return [[UIColor colorWithRed:((float)red)/255.0
                           green:((float)green)/255.0
                            blue:((float)blue)/255.0
                           alpha:((float)alpha)/255.0] retain];
}

@implementation ICRecipientPickerItem

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createComplete];
    }
    return self;
}

-(id)init{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self createComplete];
    }
    return self;
}

-(void)dealloc{
    _delegate = nil;
    [_unselectedBGColor release];
    [_selectedBGColor release];
    [_unselectedTextColor release];
    [_selectedTextColor release];
    [_unselectedBorderColor release];
    [_selectedBorderColor release];
    [_object release];
    [super dealloc];
}

-(void)createComplete{
    _unselectedBGColor = DEFAULT_BG_COLOR;
    _selectedBGColor = DEFAULT_SELECTED_BG_COLOR;
    _unselectedTextColor = DEFAULT_TEXT_COLOR;
    _selectedTextColor = DEFAULT_SELECTED_TEXT_COLOR;
    _unselectedBorderColor = DEFAUL_BORDER_COLOR;
    _selectedBorderColor = DEFAUL_BORDER_COLOR;
    
    _pickerTextLabelPadding = ITEM_TEXTLABELPADDING_LEFT_AND_RIGHT;
    _highlightTouches = YES;
    self.backgroundColor = DEFAULT_BG_COLOR;
}

-(UILabel*)textLabel{
    if(!_textLabel){
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        [_textLabel release];
    }
    return _textLabel;
}

-(void)layoutSubviews{
    self.textLabel.frame = CGRectMake(_pickerTextLabelPadding, self.bounds.origin.y, self.bounds.size.width-2*_pickerTextLabelPadding, self.bounds.size.height);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.height/2;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [_unselectedBorderColor CGColor];
    [super layoutSubviews];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if (selected && animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.backgroundColor = _selectedBGColor;
        self.textLabel.textColor = _selectedTextColor;
        [UIView commitAnimations];
    }else if (selected){ //animated is no
        self.backgroundColor = _selectedBGColor;
        self.textLabel.textColor = _selectedTextColor;
    }else if (animated){ // selected is no
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.backgroundColor = _unselectedBGColor;
        self.textLabel.textColor = _unselectedTextColor;
        [UIView commitAnimations];
    }else{ // selected and animated are no
        self.backgroundColor = _unselectedBGColor;
        self.textLabel.textColor = _unselectedTextColor;
    }
    _isSelected = selected;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    _touchBegan = touchPoint;
    if (_highlightTouches) {
        [self setSelected:YES animated:NO];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if (!CGRectContainsPoint(self.bounds, touchPoint)) {
        [self touchesCancelled:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint)) {
        [self touchesCancelled:touches withEvent:event];
        if ([self.delegate respondsToSelector:@selector(selectedPickerItem:)]) {
            [self.delegate selectedPickerItem:self];
        }
        return;
    }
    [self setSelected:NO animated:NO];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self setSelected:NO animated:NO];
}
@end
