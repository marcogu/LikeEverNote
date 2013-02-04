//
//  ICNoteViewController.h
//  superTabNavigator
//
//  Created by marco on 13-1-14.
//  Copyright (c) 2013年 marco. All rights reserved.
//

@class CardView;
@class ICNoteViewControllerDelegate;
@protocol ICNoteViewControllerDelegate;




#define kDefaultAnimationDuration 0.3
#define kDefaultMaximizedScalingFactor 1.00
#define kDefaultShadowOffset CGSizeMake(0, -5)
#define kDefaultCornerRadius 5.0
#define kDefaultShadowOpacity 0.60
#define kDefaultShadowRadius 7.0
#define kDefaultShadowColor [UIColor blackColor]
#define kDefaultShadowEnabled YES




enum {
    ICControllerCardStateHiddenBottom,    //Card is hidden off screen (Below bottom of visible area)
    ICControllerCardStateHiddenTop,       //Card is hidden off screen (At top of visible area)
    ICControllerCardStateDefault,         //Default location for the card
    ICControllerCardStateFullScreen       //Highlighted location for the card
};
typedef UInt32 ICControllerCardState;




@protocol PreviewableControllerProtocol
@optional
@property(nonatomic, retain) UIView* view;
-(CGFloat)scalingFactorForIndex:(int)index;
-(CGFloat)defaultVerticalOriginForIndex:(int)index;
@end



@protocol CardViewProtocol
@property(nonatomic, retain) NSObject<ICNoteViewControllerDelegate>* delegate;
- (void) setState:(int)state animated:(BOOL) animated;
@end



@protocol ICNoteViewControllerDelegate <NSObject>
@optional
//Called on any time a state change has occured - even if a state has changed to itself - (i.e. from KLControllerCardStateDefault to KLControllerCardStateDefault)
-(void)controllerCard:(NSObject<CardViewProtocol>*)card didChangeToState:(int)toState fromState:(int)fromState;
//Called when user is panning and a the card has travelled X percent of the distance to the top - Used to redraw other cards during panning fanout
-(void)controllerCard:(NSObject<CardViewProtocol>*)card didUpdatePanPercentage:(CGFloat) percentage;
@end



@protocol NoteViewControllerDataSource
- (NSInteger)numberOfControllerCardsInNoteView:(UIViewController<PreviewableControllerProtocol>*) noteView;
- (UIViewController *)noteView:(UIViewController<PreviewableControllerProtocol>*)noteView viewControllerForRowAtIndexPath:(NSIndexPath *)indexPath;
@end