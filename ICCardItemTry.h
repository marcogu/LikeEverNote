//
//  ICCardItemTry.h
//  superTabNavigator
//
//  Created by marco on 13-3-29.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ICNoteControllerProtocol.h"
#import <Three20/Three20.h>


@interface ICCardItemTry : TTImageView<CardViewProtocol>
{
    CGFloat originY;
    CGFloat scalingFactor;
    NSInteger index;
    UIImage* snapshot;
    
    UIPanGestureRecognizer* panGesture;
    UILongPressGestureRecognizer* pressGesture;
}
// the card view controller
@property (nonatomic, retain) UIViewController<PreviewableControllerProtocol>* scheduleController;
// the card view controller delegate. will be daprecate
@property (nonatomic, retain) NSObject<ICNoteViewControllerDelegate>* cardCtrlDelegate;
// card view current state.
@property (nonatomic) ICControllerCardState state;
@property (nonatomic) CGFloat panOriginOffset;
// card item value object, the member controller instance factory.
@property (nonatomic, retain) CardItemRegister* cardItem;

// change card view state with animate.
-(void) setState:(ICControllerCardState)state animated:(BOOL) animated;
@end
