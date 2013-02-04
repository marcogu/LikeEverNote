//
//  ICCardItem.m
//  superTabNavigator
//
//  Created by marco on 13-2-4.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ICCardItem.h"

@interface ICCardItem ()

@end

@implementation ICCardItem

-(id)initWithSnapshot:(UIImage *)snapshotImg scheduler:(UIViewController<PreviewableControllerProtocol>*)nvcontroller index:(NSInteger)idx
{
    CGRect frame = {{0,0},snapshotImg.size};
    self = [super initWithFrame:frame];
    if (self)
    {   //init local variable
        index = idx;
        snapshot = snapshotImg;
        self.scheduleController = nvcontroller;
        // init self layout
        originY = [nvcontroller defaultVerticalOriginForIndex:index];
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask: UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        // create content view and add to view.
        self.snapshotImg = [[UIImageView alloc] initWithImage:snapshotImg];
        [self addSubview: _snapshotImg];
        // add gensture for content view.
        UIPanGestureRecognizer* panGesture =
        [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformPanGesture:)];
        UILongPressGestureRecognizer* pressGesture =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformLongPress:)];
        _snapshotImg.userInteractionEnabled = YES;
        [_snapshotImg addGestureRecognizer:panGesture];
        [_snapshotImg addGestureRecognizer:pressGesture];
        
        [self setState:ICControllerCardStateDefault
              animated:NO];
    }
    return self;
}

-(void) setState:(ICControllerCardState)state animated:(BOOL) animated
{
    if (animated)
    {
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
            [self setState:state animated:NO];
        }];
        return;
    }
    
    switch (state)
    {
        case ICControllerCardStateFullScreen:
            [self expandCardToFullSize: animated];
            [self setYCoordinate: 0];
            break;
            
        case ICControllerCardStateDefault:
            [self shrinkCardToScaledSize: animated];
            [self setYCoordinate: originY];
            break;
            //Hidden State - Bottom : Move it off screen and far enough down that the shadow does not appear on screen
        case ICControllerCardStateHiddenBottom:
            [self setYCoordinate:snapshot.size.height+ abs(kDefaultShadowOffset.height)*3];
            break;
            //Hidden State - Top
        case ICControllerCardStateHiddenTop:
            [self setYCoordinate: 0];
            break;
        default:
            break;
    }
    //start new animation.
//    ICControllerCardState lastState = self.state;
//    [self setState:state];
    //Notify the delegate
//    if ([self.delegate respondsToSelector:@selector(controllerCard:didChangeToState:fromState:)])
//    {
//        [self.delegate controllerCard:self
//                     didChangeToState:state fromState: lastState];
//    }
}

-(void)dealloc
{
    [_snapshotImg release];
    [_scheduleController release];
    [super dealloc];
}

#pragma mark - layout method

-(void) setYCoordinate:(CGFloat)yValue
{
    [self setFrame:CGRectMake(self.frame.origin.x, yValue, self.frame.size.width, self.frame.size.height)];
}

-(void) updateScalingFactor
{
    if (!scalingFactor)
        scalingFactor =  [self.scheduleController scalingFactorForIndex: index];
}

-(void) expandCardToFullSize:(BOOL) animated
{
    [self updateScalingFactor];
    if (animated)
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{[self expandCardToFullSize:NO];}];
    else
        [self setTransform: CGAffineTransformMakeScale(kDefaultMaximizedScalingFactor, kDefaultMaximizedScalingFactor)];
}

-(void) shrinkCardToScaledSize:(BOOL) animated
{
    [self updateScalingFactor];
    //If animated then animate the shrinking else no animation
    if (animated)
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{[self shrinkCardToScaledSize:NO];}];
    else
        [self setTransform: CGAffineTransformMakeScale(scalingFactor, scalingFactor)];
}



@end
