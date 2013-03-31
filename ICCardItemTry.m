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


@interface ICCardItemTry(){
    CGRect smlFrame;
}
@end


@implementation ICCardItemTry

-(id)initWithItem:(CardItemRegister*)item scheduler:(UIViewController<PreviewableControllerProtocol>*)nvcontroller index:(NSInteger)idx{
    self.cardItem = item;
    // init frame
    UIImage* previewImg = [item.getViewCtrl previewImageInCording];
    imgSize = previewImg.size;
    originY = [nvcontroller defaultVerticalOriginForIndex:idx];
    float smlSizW = imgSize.width*0.95;
    smlFrame = CGRectMake((imgSize.width - smlSizW)/2, originY, smlSizW, imgSize.height*0.95);
    self = [super initWithFrame:smlFrame];
    
    if (self)
    {   //init local variable
        index = idx;
        self.scheduleController = nvcontroller;
        item.cardInstance = self;
        self.cardCtrlDelegate = (NSObject<ICNoteViewControllerDelegate>*)self.scheduleController; //will delete
        // init self layout
//        [self setAutoresizesSubviews:YES];
//        [self setAutoresizingMask: UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        self.backgroundColor = [UIColor clearColor];
        self.style = [self snapshotImgStyle:previewImg];
        // add gensture for content view.
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformPanGesture:)];
        pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformLongPress:)];
        [self addGestureRecognizer:panGesture];
        [self addGestureRecognizer:pressGesture];
//        [self updateScalingFactor];
        self.state = ICControllerCardStateDefault;
//        [self setState:ICControllerCardStateDefault animated:NO];
    }
    return self;
}

-(void) dealloc{
    //    [snapshot release];
    [_scheduleController release];
    [_cardCtrlDelegate release];
    [pressGesture release];
    [panGesture release];
    [_cardItem release];
    [super dealloc];
}

-(TTStyle*)snapshotImgStyle:(UIImage*)img{
    TTStyle* result =
    [TTShapeStyle styleWithShape:
    [TTRoundedRectangleShape shapeWithTopLeft:5 topRight:5 bottomRight:0 bottomLeft:0] next:
    [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.5) blur:4 offset:CGSizeMake(0, -5) next:
//     [TTInsetStyle styleWithInset:UIEdgeInsetsMake(6, 6, 6, 6) next:
    [TTImageStyle styleWithImage:img next:
    
     nil]
     ]]; //]]
    return result;
}

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

-(void) updateScalingFactor
{
    if (!scalingFactor)
        scalingFactor =  [self.scheduleController scalingFactorForIndex: index];
}

#pragma mark - action handler

-(void) didPerformLongPress:(UILongPressGestureRecognizer*) recognizer{
    if (self.state == ICControllerCardStateDefault && recognizer.state == UIGestureRecognizerStateEnded){
        [self playAnimationToState:ICControllerCardStateFullScreen];
    }
}

-(void) didPerformPanGesture:(UIPanGestureRecognizer*) recognizer
{
    CGPoint location = [recognizer locationInView: _scheduleController.view];
    CGPoint translation = [recognizer translationInView: self];
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            if (self.state == ICControllerCardStateFullScreen){
//                snapshot = self.cardItem.getViewCtrl.previewImageInCording;
//                [self.snapshotImg setImage:snapshot];
                [self.scheduleController.navigationController popViewControllerAnimated:NO];
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
        case UIGestureRecognizerStateEnded: {
            ICControllerCardState willState = [self shouldReturnToState:_state fromPoint:[recognizer translationInView:self]] ? _state :
            _state == ICControllerCardStateFullScreen ? ICControllerCardStateDefault : ICControllerCardStateFullScreen;
            [self playAnimationToState:willState];
        }
        break;
        default:
            break;
    }
}

/*
-(void)playAnimationToState:(ICControllerCardState) state{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kDefaultAnimationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    ICControllerCardState lastState = self.state;
    self.state = state;
    [self setState:state animated:YES];
    if ([self.cardCtrlDelegate respondsToSelector:@selector(controllerCard:didChangeToState:fromState:)]){
        [self.cardCtrlDelegate controllerCard:self didChangeToState:_state fromState:lastState];
    }
    [UIView commitAnimations];
}
 */

-(void)playAnimationToState:(ICControllerCardState) state{
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
//    theGroup.delegate = self;
    theGroup.duration = kDefaultAnimationDuration;
    theGroup.removedOnCompletion = YES;
//    theGroup.animations = [self getCAAnimationsByState:state];
    float deltay = 0;
    self.state = state;
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    switch (state) {
        case ICControllerCardStateFullScreen:{
            ba.fromValue = [NSNumber numberWithFloat:self.frame.origin.y];
            deltay = 0;
            ba.toValue = [NSNumber numberWithFloat:deltay];
        }break;
        case ICControllerCardStateDefault:{
            ba.fromValue = [NSNumber numberWithFloat:self.frame.origin.y];
            deltay = smlFrame.origin.y;
            ba.toValue = [NSNumber numberWithFloat:deltay];
        }break;
        case ICControllerCardStateHiddenBottom:
            break;
        case ICControllerCardStateHiddenTop:
            break;
        default:
            break;
    }
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	transformAnimation.removedOnCompletion = YES;
	transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.15, 1.15, 1.0)];
    
    theGroup.animations = [NSArray arrayWithObjects:ba, transformAnimation, nil];
    [self.layer addAnimation:theGroup forKey:@"stateChange"];
    
    CGRect rect = {self.frame.origin.x, deltay, self.frame.size};
    self.frame = rect;
    
}


//-(void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context{
//    if (finished)
//        [self pushToMemberControllerIfSelfIsCurrent];
//}

-(NSInteger)getCardIndex{
    return index;
}

-(CGPoint) origin {
    return CGPointMake(0, originY);
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

-(void) setYCoordinate:(CGFloat)yValue
{
    CGRect rect = CGRectMake(self.frame.origin.x, yValue, self.frame.size.width, self.frame.size.height);
    [self setFrame:rect];
}

-(void) setState:(ICControllerCardState)state animated:(BOOL) animated {
    switch (state) {
        case ICControllerCardStateFullScreen:
//            self.frame = CGRectMake(self.frame.origin.x, 0, smlFrame.size.width, smlFrame.size.height); // just change position
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, imgSize.width, imgSize.height);//just change size
            break;
        case ICControllerCardStateDefault:
//            self.frame = smlFrame;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, smlFrame.size.width, smlFrame.size.height);//just change size
            break;
        case ICControllerCardStateHiddenBottom:
            [self setYCoordinate:imgSize.height+ abs(kDefaultShadowOffset.height)*3];
            break;
        case ICControllerCardStateHiddenTop:
            [self setYCoordinate: 0];
            break;
        default:
            break;
    }
}
@end
