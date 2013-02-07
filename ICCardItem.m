//
//  ICCardItem.m
//  superTabNavigator
//
//  Created by marco on 13-2-4.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ICCardItem.h"
#import <QuartzCore/QuartzCore.h>

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
    ICControllerCardState lastState = self.state;
    [self setState:state];
    //Notify the delegate
    if ([self.delegate respondsToSelector:@selector(controllerCard:didChangeToState:fromState:)])
        [self.delegate controllerCard:self didChangeToState:state fromState: lastState];
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame: frame];
    [self redrawShadow];
}

-(void)dealloc
{
    [_snapshotImg release];
    [_scheduleController release];
    [super dealloc];
}

-(BOOL)isNeedToInvokeDelegate:(CGFloat)translationY
{
    BOOL rs = translationY > 0 && ((self.state == ICControllerCardStateFullScreen && self.frame.origin.y < originY) ||
                                   (self.state == ICControllerCardStateDefault && self.frame.origin.y > originY));
    if (rs)
    {
        if ([self.delegate respondsToSelector:@selector(controllerCard:didUpdatePanPercentage:)] )
            [self.delegate controllerCard:self didUpdatePanPercentage: [self percentageDistanceTravelled]];
    }
    return rs;
}

-(BOOL) shouldReturnToState:(ICControllerCardState) state fromPoint:(CGPoint) point
{
    if (state == ICControllerCardStateFullScreen)
        return ABS(point.y) < 50;//self.navigationController.navigationBar.frame.size.height
    else if (state == ICControllerCardStateDefault)
        return point.y > -50;//-self.navigationController.navigationBar.frame.size.height
    return NO;
}

-(CGFloat) percentageDistanceTravelled
{
    return self.frame.origin.y/originY;
}

#pragma mark - layout method

-(void) setYCoordinate:(CGFloat)yValue
{
    CGRect rect = CGRectMake(self.frame.origin.x, yValue, self.frame.size.width, self.frame.size.height);
    [self setFrame:rect];
    NSLog(@"setYCoordinate:%@", NSStringFromCGRect(rect));
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
    if (animated)
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{[self shrinkCardToScaledSize:NO];}];
    else
        [self setTransform: CGAffineTransformMakeScale(scalingFactor, scalingFactor)];
}

#pragma mark - action handler

-(void) didPerformLongPress:(UILongPressGestureRecognizer*) recognizer
{
    if (self.state == ICControllerCardStateDefault && recognizer.state == UIGestureRecognizerStateEnded)
        [self setState:ICControllerCardStateFullScreen animated:YES];
}

-(void) didPerformPanGesture:(UIPanGestureRecognizer*) recognizer
{
    CGPoint location = [recognizer locationInView: _scheduleController.view];
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
            break;
            
        default:
            break;
    }
}

@end
