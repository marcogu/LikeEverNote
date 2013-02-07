//
//  CardView.m
//  superTabNavigator
//
//  Created by marco on 13-1-14.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CardView.h"

@implementation CardView

-(id) initWithNoteViewController: (UIViewController<PreviewableControllerProtocol>*) noteView navigationController:(UINavigationController*) navigationController index:(NSInteger) idx
{
    index = idx;
    originY = [noteView defaultVerticalOriginForIndex: index];
    self.noteViewController = noteView;
    self.navigationController = navigationController;
    
    self = [super initWithFrame: navigationController.view.bounds];
    if (self)
    {
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask: UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self addSubview: navigationController.view];
        
        [self.navigationController.view.layer setCornerRadius: 5.0f];
        [self.navigationController.view setClipsToBounds:YES];
        
        UIPanGestureRecognizer* panGesture =
            [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformPanGesture:)];
        UILongPressGestureRecognizer* pressGesture =
            [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformLongPress:)];
        [pressGesture setMinimumPressDuration: 0.2f];
        
        [self.navigationController.navigationBar addGestureRecognizer: panGesture];
        [self.navigationController.navigationBar addGestureRecognizer:pressGesture];
        
        [self setState:ICControllerCardStateDefault
              animated:NO];
    }
    return self;
}

-(void) redrawShadow
{
    if (kDefaultShadowEnabled)
    {
        UIBezierPath *path  =  [UIBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:kDefaultCornerRadius];
        
        [self.layer setShadowOpacity: kDefaultShadowOpacity];
        [self.layer setShadowOffset: kDefaultShadowOffset];
        [self.layer setShadowRadius: kDefaultShadowRadius];
        [self.layer setShadowColor: [kDefaultShadowColor CGColor]];
        [self.layer setShadowPath: [path CGPath]];
    }
}

- (void) setState:(ICControllerCardState)state animated:(BOOL) animated
{   // stop old animation if needed.
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
            [self setYCoordinate: self.noteViewController.view.frame.size.height + abs(kDefaultShadowOffset.height)*3];
            break;
        //Hidden State - Top
        case ICControllerCardStateHiddenTop:
            [self setYCoordinate: 0];
            break;
        default:
            break;
    }
    //start new animation.
    ICControllerCardState lastState = self.state;
    [self setState:state];
    //Notify the delegate
    if ([self.delegate respondsToSelector:@selector(controllerCard:didChangeToState:fromState:)])
    {
        [self.delegate controllerCard:self
              didChangeToState:state fromState: lastState];
    }
}

-(void) updateScalingFactor
{
    if (!scalingFactor)
        scalingFactor =  [self.noteViewController scalingFactorForIndex: index];
}

-(void) setYCoordinate:(CGFloat)yValue
{
    CGRect rect = CGRectMake(self.frame.origin.x, yValue, self.frame.size.width, self.frame.size.height);
    [self setFrame:rect];
    NSLog(@"setYCoordinate:%@", NSStringFromCGRect(rect));
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

-(BOOL) shouldReturnToState:(ICControllerCardState) state fromPoint:(CGPoint) point
{
    if (state == ICControllerCardStateFullScreen)
        return ABS(point.y) < self.navigationController.navigationBar.frame.size.height;
    else if (state == ICControllerCardStateDefault)
        return point.y > -self.navigationController.navigationBar.frame.size.height;
    return NO;
}

-(void) didPerformPanGesture:(UIPanGestureRecognizer*) recognizer
{
    CGPoint location = [recognizer locationInView: self.noteViewController.view];
    CGPoint translation = [recognizer translationInView: self];
    
    NSLog(@"location=%@,translation=%@", NSStringFromCGPoint(location), NSStringFromCGPoint(translation));
    
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            if (self.state == ICControllerCardStateFullScreen)
                [self shrinkCardToScaledSize:YES];
            self.panOriginOffset = [recognizer locationInView: self].y;
            break;
        
        case UIGestureRecognizerStateChanged:
            [self isNeedToInvokeDelegate:translation.y];
            [self setYCoordinate: location.y - self.panOriginOffset];
            break;
        //Check if it should return to the origin location
        case UIGestureRecognizerStateEnded:
            [self shouldReturnToState: self.state fromPoint: [recognizer translationInView:self]] ?
                [self setState: self.state animated:YES]
            :
                [self setState: self.state == ICControllerCardStateFullScreen? ICControllerCardStateDefault : ICControllerCardStateFullScreen
                      animated:YES];
            NSLog(@"---------------drag end---------------");
            break;
            
        default:
            break;
    }
}

-(BOOL)isNeedToInvokeDelegate:(CGFloat)translationY
{
    //if state is full screen:
    //Notify delegate so it can update the coordinates of the other cards unless user has travelled past the origin y coordinate
    // if state is default:
    //Implements behavior such that when originating at the default position and scrolling down, all other cards below the scrolling card move down at the same rate
    BOOL rs = translationY > 0 && ((self.state == ICControllerCardStateFullScreen && self.frame.origin.y < originY) ||
                                       (self.state == ICControllerCardStateDefault && self.frame.origin.y > originY));
    if (rs)
    {
        if ([self.delegate respondsToSelector:@selector(controllerCard:didUpdatePanPercentage:)] )
            [self.delegate controllerCard:self didUpdatePanPercentage: [self percentageDistanceTravelled]];
    }
    return rs;
}

-(void) didPerformLongPress:(UILongPressGestureRecognizer*) recognizer
{
    if (self.state == ICControllerCardStateDefault && recognizer.state == UIGestureRecognizerStateEnded)
        [self setState:ICControllerCardStateFullScreen animated:YES];
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame: frame];
    [self redrawShadow];
}

-(CGFloat) percentageDistanceTravelled
{
    return self.frame.origin.y/originY;
}
@end
