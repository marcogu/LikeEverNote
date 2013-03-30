//
//  ICCardItem.m
//  superTabNavigator
//
//  Created by marco on 13-2-4.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ICCardItem.h"
#import "CardItemRegister.h"

@interface ICCardItem ()
{
    UIPanGestureRecognizer* panGesture;
    UILongPressGestureRecognizer* pressGesture;
}
@end

@implementation ICCardItem

-(id)initWithItem:(CardItemRegister*)item scheduler:(UIViewController<PreviewableControllerProtocol>*)nvcontroller index:(NSInteger)idx {
    self.cardItem = item;
    UIImage* previewImg = [item.getViewCtrl previewImageInCording];
    CGRect frame = {{0,0},previewImg.size};
    self = [super initWithFrame:frame];
    if (self) {
        //init local variable
        index = idx;
        snapshot = previewImg;
        self.scheduleController = nvcontroller;
        item.cardInstance = self;
        self.cardCtrlDelegate = (NSObject<ICNoteViewControllerDelegate>*)self.scheduleController; //will delete
        // init self layout
        originY = [nvcontroller defaultVerticalOriginForIndex:index];
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask: UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        // create content view and add to view.
        [self snapshotImg];
        // add gensture for content view.
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformPanGesture:)];
        pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didPerformLongPress:)];
        _snapshotImg.userInteractionEnabled = YES;
        [_snapshotImg addGestureRecognizer:panGesture];
        [_snapshotImg addGestureRecognizer:pressGesture];
        
        [self updateScalingFactor];
        self.state = ICControllerCardStateDefault;
        [self setState:ICControllerCardStateDefault animated:NO];
    }
    return self;
}

-(UIImageView*)snapshotImg{
    if (!_snapshotImg) {
        _snapshotImg = [[UIImageView alloc] initWithImage:snapshot];
        _snapshotImg.layer.cornerRadius = 5;
        // 如果不使用这句,动画性能能达到最好
        _snapshotImg.clipsToBounds = YES;
        [self addSubview: _snapshotImg];
        [_snapshotImg release];
    }
    return _snapshotImg;
}

-(void) dealloc{
    [_snapshotImg release];
    [_scheduleController release];
    [_cardCtrlDelegate release];
    [pressGesture release];
    [panGesture release];
    [_cardItem release];
    [super dealloc];
}

-(void) redrawShadow {
    if (kDefaultShadowEnabled) {
        UIBezierPath *path  =  [UIBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:kDefaultCornerRadius];
        
        [self.layer setShadowOpacity: kDefaultShadowOpacity];
        [self.layer setShadowOffset: kDefaultShadowOffset];
        [self.layer setShadowRadius: kDefaultShadowRadius];
        [self.layer setShadowColor: [kDefaultShadowColor CGColor]];
        [self.layer setShadowPath: [path CGPath]];
    }
}

-(void) setState:(ICControllerCardState)state animated:(BOOL) animated {
    switch (state) {
        case ICControllerCardStateFullScreen:
            [self setTransform: CGAffineTransformMakeScale(kDefaultMaximizedScalingFactor, kDefaultMaximizedScalingFactor)];
            [self setYCoordinate: 0];
            break;
        case ICControllerCardStateDefault:
            [self setTransform: CGAffineTransformMakeScale(scalingFactor, scalingFactor)];
            [self setYCoordinate: originY];
            break;
        case ICControllerCardStateHiddenBottom:
            [self setYCoordinate:snapshot.size.height+ abs(kDefaultShadowOffset.height)*3];
            break;
        case ICControllerCardStateHiddenTop:
            [self setYCoordinate: 0];
            break;
        default:
            break;
    }
}

-(void) setFrame:(CGRect)frame{
    [super setFrame: frame];
    [self redrawShadow];
}

-(BOOL)isNeedToInvokeDelegate:(CGFloat)translationY{
    BOOL rs = translationY > 0 && ((self.state == ICControllerCardStateFullScreen && self.frame.origin.y < originY) ||
                                   (self.state == ICControllerCardStateDefault && self.frame.origin.y > originY));
    if (rs) {
        if ([self.cardCtrlDelegate respondsToSelector:@selector(controllerCard:didUpdatePanPercentage:)] )
            [self.cardCtrlDelegate controllerCard:self didUpdatePanPercentage: [self percentageDistanceTravelled]];
    }
    return rs;
}

-(BOOL) shouldReturnToState:(ICControllerCardState) state fromPoint:(CGPoint) point{
    if (state == ICControllerCardStateFullScreen)
        return ABS(point.y) < 50;
    else if (state == ICControllerCardStateDefault)
        return point.y > -50;
    return NO;
}

-(CGFloat) percentageDistanceTravelled{
    return self.frame.origin.y/originY;
}

#pragma mark - layout method

-(void) setYCoordinate:(CGFloat)yValue{
    CGRect rect = CGRectMake(self.frame.origin.x, yValue, self.frame.size.width, self.frame.size.height);
    [self setFrame:rect];
}

-(void) updateScalingFactor{
    if (!scalingFactor)
        scalingFactor =  [self.scheduleController scalingFactorForIndex: index];
}

#pragma mark - action handler

-(void) didPerformLongPress:(UILongPressGestureRecognizer*) recognizer{
    if (self.state == ICControllerCardStateDefault && recognizer.state == UIGestureRecognizerStateEnded){
        [self playAnimationToState:ICControllerCardStateFullScreen];
    }
}

-(void)playAnimationToState:(ICControllerCardState) state{
    [UIView beginAnimations:[NSString stringWithFormat:@"iccarditem%d",index] context:NULL];
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

-(void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context{
    if (finished)
        [self pushToMemberControllerIfSelfIsCurrent];
}

-(void) didPerformPanGesture:(UIPanGestureRecognizer*)recognizer {
    CGPoint location = [recognizer locationInView: _scheduleController.view];
    CGPoint translation = [recognizer translationInView: self];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (self.state == ICControllerCardStateFullScreen){
                snapshot = self.cardItem.getViewCtrl.previewImageInCording;
                [self.snapshotImg setImage:snapshot];
                [self.scheduleController.navigationController popViewControllerAnimated:NO];
                [self setTransform: CGAffineTransformMakeScale(scalingFactor, scalingFactor)];
                [_snapshotImg addGestureRecognizer:panGesture];
            }
            self.panOriginOffset = [recognizer locationInView: self].y;
            break;
        case UIGestureRecognizerStateChanged:
            [self isNeedToInvokeDelegate:translation.y];
            float deltaFix = location.y - self.panOriginOffset + (_state == ICControllerCardStateFullScreen ? 20 : 0);
            [self setYCoordinate: deltaFix];
            break;
        case UIGestureRecognizerStateEnded:{
            ICControllerCardState willState = [self shouldReturnToState:_state fromPoint:[recognizer translationInView:self]] ? _state :
                                _state == ICControllerCardStateFullScreen ? ICControllerCardStateDefault : ICControllerCardStateFullScreen;
            [self playAnimationToState:willState];
        }break;
        default:
            break;
    }
}

-(void)pushToMemberControllerIfSelfIsCurrent{
    if (self.state == ICControllerCardStateFullScreen){
        UIViewController<NoteControllerProtocal>* mc = self.cardItem.getViewCtrl;
        [mc.gestureRecognizerTarget addGestureRecognizer:panGesture];
        [self.scheduleController.navigationController pushViewController:_cardItem.getViewCtrl animated:NO];
    }
    else if(self.state == ICControllerCardStateDefault){
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