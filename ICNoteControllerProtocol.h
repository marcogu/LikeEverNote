//
//  ICNoteViewController.h
//  superTabNavigator
//
//  Created by marco on 13-1-14.
//  Copyright (c) 2013年 marco. All rights reserved.
//

@class CardView;

@protocol PreviewableControllerProtocol
@optional
@property(nonatomic, retain)UIView* view;
-(CGFloat)scalingFactorForIndex:(int)index;
-(CGFloat)defaultVerticalOriginForIndex:(int)index;
@end



@protocol ICNoteViewControllerDelegate <NSObject>
@optional
//Called on any time a state change has occured - even if a state has changed to itself - (i.e. from KLControllerCardStateDefault to KLControllerCardStateDefault)
-(void)controllerCard:(CardView*)card didChangeToState:(int)toState fromState:(int)fromState;
//Called when user is panning and a the card has travelled X percent of the distance to the top - Used to redraw other cards during panning fanout
-(void)controllerCard:(CardView*)card didUpdatePanPercentage:(CGFloat) percentage;
@end



@protocol CardViewProtocol
@property (nonatomic, strong) NSObject<ICNoteViewControllerDelegate>* delegate;
- (void) setState:(int)state animated:(BOOL) animated;
@end




@protocol NoteViewControllerDataSource
- (NSInteger)numberOfControllerCardsInNoteView:(UIViewController<PreviewableControllerProtocol>*) noteView;
- (UIViewController *)noteView:(UIViewController<PreviewableControllerProtocol>*)noteView viewControllerForRowAtIndexPath:(NSIndexPath *)indexPath;
@end