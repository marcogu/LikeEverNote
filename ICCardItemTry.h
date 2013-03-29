//
//  ICCardItemTry.h
//  superTabNavigator
//
//  Created by marco on 13-3-29.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ICNoteControllerProtocol.h"

@interface ICCardItemTry : UIView<CardViewProtocol>
{
    CGFloat originY;
    CGFloat scalingFactor;
    NSInteger index;
    UIImage* snapshot;
    
    UIPanGestureRecognizer* panGesture;
    UILongPressGestureRecognizer* pressGesture;
}
// the member controller preview image
@property (nonatomic, retain) UIImageView* snapshotImg;
// the card view controller
@property (nonatomic, retain) UIViewController<PreviewableControllerProtocol>* scheduleController;
// the card view controller delegate. will be daprecate
@property (nonatomic, retain) NSObject<ICNoteViewControllerDelegate>* delegate;
// card view current state.
@property (nonatomic) ICControllerCardState state;
@property (nonatomic) CGFloat panOriginOffset;
// card item value object, the member controller instance factory.
@property (nonatomic, retain) CardItemRegister* cardItem;

// change card view state with animate.
-(void) setState:(ICControllerCardState)state animated:(BOOL) animated;
@end
