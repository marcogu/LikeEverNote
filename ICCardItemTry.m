//
//  ICCardItemTry.m
//  superTabNavigator
//
//  Created by marco on 13-3-29.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


#import "ICCardItemTry.h"
#import "CardItemRegister.h"

@implementation ICCardItemTry

-(id)initWithItem:(CardItemRegister*)item scheduler:(UIViewController<PreviewableControllerProtocol>*)nvcontroller index:(NSInteger)idx
{
    self.cardItem = item;
    UIImage* previewImg = [item.getViewCtrl previewImageInCording];
    CGRect frame = {{0,0},previewImg.size};
    self = [super initWithFrame:frame];
    if (self)
    {   //init local variable
        index = idx;
        snapshot = previewImg;
        self.scheduleController = nvcontroller;
        item.cardInstance = self;
        self.cardCtrlDelegate = (NSObject<ICNoteViewControllerDelegate>*)self.scheduleController; //will delete
        // init self layout
        originY = [nvcontroller defaultVerticalOriginForIndex:index];
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask: UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        // add gensture for content view.
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformPanGesture:)];
        pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformLongPress:)];
        [self addGestureRecognizer:panGesture];
        [self addGestureRecognizer:pressGesture];
        self.backgroundColor = [UIColor clearColor];
        self.style = [self snapshotImgStyle:previewImg];
        
        [self setState:ICControllerCardStateDefault
              animated:NO];
    }
    return self;
}

//-(TTImageView*)snapshotImg{
//    if (!_snapshotImg) {
//        _snapshotImg = [[TTImageView alloc] initWithFrame:CGRectMake(0, 0, snapshot.size.width, snapshot.size.height)];
//        _snapshotImg.style = [self snapshotImgStyle];
////        _snapshotImg.backgroundColor = [UIColor clearColor];
//        [self addSubview: _snapshotImg];
//        [_snapshotImg release];
//    }
//    return _snapshotImg;
//}

-(TTStyle*)snapshotImgStyle:(UIImage*)img{
    TTStyle* result =
    [TTShapeStyle styleWithShape:
    [TTRoundedRectangleShape shapeWithTopLeft:5 topRight:5 bottomRight:0 bottomLeft:0] next:
    [TTImageStyle styleWithImage:img next:nil
//    [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.5) blur:4 offset:CGSizeMake(2, 2) next:
//     nil]
     ]];
    return result;
}

-(void) dealloc{
//    [snapshot release];
    [_scheduleController release];
    [_delegate release];
    [pressGesture release];
    [panGesture release];
    [_cardItem release];
    [super dealloc];
}

//-(void) redrawShadow
//{
//    if (kDefaultShadowEnabled)
//    {
//        UIBezierPath *path  =  [UIBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:kDefaultCornerRadius];
//        
//        [self.layer setShadowOpacity: kDefaultShadowOpacity];
//        [self.layer setShadowOffset: kDefaultShadowOffset];
//        [self.layer setShadowRadius: kDefaultShadowRadius];
//        [self.layer setShadowColor: [kDefaultShadowColor CGColor]];
//        [self.layer setShadowPath: [path CGPath]];
//    }
//}

-(void) setState:(ICControllerCardState)state animated:(BOOL) animated
{
    if (animated)
    {
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
            [self setState:state animated:NO];
        } completion:^(BOOL finished) {
            if (finished)
                [self pushToMemberControllerIfSelfIsCurrent];
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
    if ([self.cardCtrlDelegate respondsToSelector:@selector(controllerCard:didChangeToState:fromState:)])
        [self.cardCtrlDelegate controllerCard:self didChangeToState:state fromState: lastState];
}

//-(void) setFrame:(CGRect)frame
//{
//    [super setFrame: frame];
//    [self redrawShadow];
//}


-(BOOL)isNeedToInvokeDelegate:(CGFloat)translationY
{
    BOOL rs = translationY > 0 && ((self.state == ICControllerCardStateFullScreen && self.frame.origin.y < originY) ||
                                   (self.state == ICControllerCardStateDefault && self.frame.origin.y > originY));
    if (rs)
    {
        if ([self.cardCtrlDelegate respondsToSelector:@selector(controllerCard:didUpdatePanPercentage:)] )
            [self.cardCtrlDelegate controllerCard:self didUpdatePanPercentage: [self percentageDistanceTravelled]];
    }
    return rs;
}

-(BOOL) shouldReturnToState:(ICControllerCardState) state fromPoint:(CGPoint) point
{
    if (state == ICControllerCardStateFullScreen)
        return ABS(point.y) < 50;
    else if (state == ICControllerCardStateDefault)
        return point.y > -50;
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
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{[self expandCardToFullSize:NO];} completion:^(BOOL finished) {
            //            NSLog(@"full screen complete");
        }];
    else
        [self setTransform: CGAffineTransformMakeScale(kDefaultMaximizedScalingFactor, kDefaultMaximizedScalingFactor)];
}

-(void) shrinkCardToScaledSize:(BOOL) animated
{
    [self updateScalingFactor];
    if (animated)
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{[self shrinkCardToScaledSize:NO];} completion:^(BOOL finished) {
            //            NSLog(@"scale size complete");
        }];
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
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            if (self.state == ICControllerCardStateFullScreen){
                snapshot = self.cardItem.getViewCtrl.previewImageInCording;
//                [self.snapshotImg setImage:snapshot];
                [self.scheduleController.navigationController popViewControllerAnimated:NO];
                [self shrinkCardToScaledSize:YES];
                [self addGestureRecognizer:panGesture];
            }
            self.panOriginOffset = [recognizer locationInView: self].y;
            break;
            
        case UIGestureRecognizerStateChanged:
            [self isNeedToInvokeDelegate:translation.y];
            if (self.state == ICControllerCardStateFullScreen) {
                [self setYCoordinate: location.y - self.panOriginOffset + 20];
            }else{
                [self setYCoordinate: location.y - self.panOriginOffset];
            }
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

-(void)pushToMemberControllerIfSelfIsCurrent{
    if (self.state == ICControllerCardStateFullScreen)
    {
        UIViewController<NoteControllerProtocal>* mc = self.cardItem.getViewCtrl;
        [mc.gestureRecognizerTarget addGestureRecognizer:panGesture];
        [self.scheduleController.navigationController pushViewController:_cardItem.getViewCtrl animated:NO];
    }
    else if(self.state == ICControllerCardStateDefault)
    {
        [self.cardItem validateOnBackground];
    }
}

-(NSInteger)getCardIndex{
    return index;
}

-(CGPoint) origin {
    return CGPointMake(0, originY);
}
@end
