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

#define kDefaultNavigationBarOverlap 0.90
#define kDefaultMinimizedScalingFactor 0.98
#define kDefaultVerticalOrigin 100
#define kDefaultNavigationControllerToolbarHeight 44


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



@class CardItemRegister;
@protocol NoteControllerProtocal;


@protocol CardViewProtocol
@property(nonatomic, retain) NSObject<ICNoteViewControllerDelegate>* delegate;
@property (nonatomic, retain) CardItemRegister* cardItem;
- (id)initWithItem:(CardItemRegister*)item scheduler:(UIViewController<PreviewableControllerProtocol>*)nvcontroller index:(NSInteger)idx;
- (void) setState:(int)state animated:(BOOL) animated;
-(NSInteger)getCardIndex;
@end



@protocol ICNoteViewControllerDelegate <NSObject>
@optional
//Called on any time a state change has occured - even if a state has changed to itself - (i.e. from KLControllerCardStateDefault to KLControllerCardStateDefault)
-(void)controllerCard:(NSObject<CardViewProtocol>*)card didChangeToState:(int)toState fromState:(int)fromState;
//Called when user is panning and a the card has travelled X percent of the distance to the top - Used to redraw other cards during panning fanout
-(void)controllerCard:(NSObject<CardViewProtocol>*)card didUpdatePanPercentage:(CGFloat) percentage;
@end




@protocol NoteViewControllerDataSource
- (NSInteger)numberOfControllerCardsInNoteView;
- (UIView<CardViewProtocol>*)cardForRowAtIdxPath:(NSInteger)idx rootCtrl:(UIViewController<PreviewableControllerProtocol>*)nvcontroller;
@end