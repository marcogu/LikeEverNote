//
//  NoteCardViewController.m
//  superTabNavigator
//
//  Created by marco on 13-1-15.
//  Copyright (c) 2013年 marco. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "NoteCardViewController.h"
#import "CardView.h"
#import "ICCardItem.h"
#import "NoteCardDatasource.h"
#import "ICNoteControllerProtocol.h"

@interface NoteCardViewController ()
@end

@implementation NoteCardViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void) viewDidLoad
{
    self.dataSource = [NoteCardDatasource getSampleInstance];
    [self reloadData];
    [super viewDidLoad];
    [self reloadInputViews];
}

#pragma mark - private method

-(UIImage*)drawUIView:(UIView*)target
{
    UIGraphicsBeginImageContextWithOptions(target.bounds.size, target.opaque, 0.0);
    [target.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(NSObject<CardViewProtocol>*)createNVCByDataIdx:(int)dataIndex
{
    UIViewController* vc = [self.dataSource noteView:self viewControllerForRowAtIndexPath:[NSIndexPath indexPathForRow:dataIndex inSection:0]];
    UINavigationController* nvgcontroller = [[UINavigationController alloc] initWithRootViewController:vc];
    // creat card
//    NSObject<CardViewProtocol>* cdContainer = [[CardView alloc] initWithNoteViewController:self
//                                                                      navigationController: nvgcontroller
//                                                                                     index:dataIndex];
    UIImage* snapshot = [self drawUIView:vc.view];
    NSObject<CardViewProtocol>* cdContainer = [[ICCardItem alloc] initWithSnapshot:snapshot scheduler:self index:dataIndex];
    
    cdContainer.delegate = self;
    [self addChildViewController:nvgcontroller];
    [nvgcontroller release];
    return cdContainer;
}

- (void) reloadData
{
    totalCards = [self.dataSource numberOfControllerCardsInNoteView];
    NSMutableArray* nvcontrollers = [NSMutableArray array];
    
    for (int count = 0; count < totalCards; count++)
    {
        NSObject<CardViewProtocol>* cdContainer = [self createNVCByDataIdx:count];
        [nvcontrollers addObject:cdContainer];
        [cdContainer release];

        [self didMoveToParentViewController:self];
    }
    self.controllerCards = nvcontrollers;
}

- (void) reloadInputViews
{
    [super reloadInputViews];
    
    //    for (CardViewProtocol* cardview in self.controllerCards)
    //    {
    //        [cardview.navigationController willMoveToParentViewController:nil];
    //        [cardview removeFromSuperview];
    //    }
    
    for (UIView* container in self.controllerCards)
        [self.view addSubview:container];
}


#pragma mark - PreviewableControllerProtocol

- (CGFloat) scalingFactorForIndex: (NSInteger) index
{
    //Items should get progressively smaller based on their index in the navigation controller array
    CGFloat result = powf(kDefaultMinimizedScalingFactor, (totalCards - index));
    return result;
}

- (CGFloat) defaultVerticalOriginForIndex: (NSInteger) index
{
    //Sum up the shrunken size of each of the cards appearing before the current index
    CGFloat originOffset = 0;
    for (int i = 0; i < index; i ++)
    {
        CGFloat scalingFactor = [self scalingFactorForIndex: i];
        originOffset += scalingFactor * kDefaultNavigationControllerToolbarHeight * kDefaultNavigationBarOverlap;
    }
    
    //Position should start at kDefaultVerticalOrigin and move down by size of nav toolbar for each additional nav controller
    return kDefaultVerticalOrigin + originOffset;
}

#pragma mark - Delegate implementation for KLControllerCard

-(void) controllerCard:(NSObject<CardViewProtocol>*)controllerCard didChangeToDisplayState:(ICControllerCardState) toState fromDisplayState:(ICControllerCardState) fromState {

    if (fromState == ICControllerCardStateDefault && toState == ICControllerCardStateFullScreen) {
        
        //For all cards above the current card move them
        for (NSObject<CardViewProtocol>* currentCard  in [self controllerCardAboveCard:controllerCard]) {
            [currentCard setState:ICControllerCardStateHiddenTop animated:YES];
        }
        for (NSObject<CardViewProtocol>* currentCard  in [self controllerCardBelowCard:controllerCard]) {
            [currentCard setState:ICControllerCardStateHiddenBottom animated:YES];
        }
    }
    else if (fromState == ICControllerCardStateFullScreen && toState == ICControllerCardStateDefault) {
        //For all cards above the current card move them back to default state
        for (NSObject<CardViewProtocol>* currentCard  in [self controllerCardAboveCard:controllerCard]) {
            [currentCard setState:ICControllerCardStateDefault animated:YES];
        }
        //For all cards below the current card move them back to default state
        for (NSObject<CardViewProtocol>* currentCard  in [self controllerCardBelowCard:controllerCard]) {
            [currentCard setState:ICControllerCardStateHiddenBottom animated:NO];
            [currentCard setState:ICControllerCardStateDefault animated:YES];
        }
    }
    else if (fromState == ICControllerCardStateDefault && toState == ICControllerCardStateDefault){
        //If the current state is default and the user does not travel far enough to kick into a new state, then  return all cells back to their default state
        for (CardView* cardBelow in [self controllerCardBelowCard: controllerCard]) {
            [cardBelow setState:ICControllerCardStateDefault animated:YES];
        }
    }
    
    //Notify the delegate of the change
    if ([self.delegate respondsToSelector:@selector(controllerCard:didChangeToDisplayState:fromDisplayState:)]) {
        [self.delegate controllerCard:controllerCard didChangeToState:toState fromState:fromState];
    }
}

- (NSArray*) controllerCardAboveCard:(NSObject<CardViewProtocol>*) card
{
    NSInteger index = [self.controllerCards indexOfObject:card];
    
    return [self.controllerCards filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(CardView* controllerCard, NSDictionary *bindings) {
        NSInteger currentIndex = [self.controllerCards indexOfObject:controllerCard];
        
        //Only return cards with an index less than the one being compared to
        return index > currentIndex;
    }]];
}

- (NSArray*) controllerCardBelowCard:(NSObject<CardViewProtocol>*) card
{
    NSInteger index = [self.controllerCards indexOfObject: card];
    
    return [self.controllerCards filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(CardView* controllerCard, NSDictionary *bindings) {
        NSInteger currentIndex = [self.controllerCards indexOfObject:controllerCard];
        
        //Only return cards with an index greater than the one being compared to
        return index < currentIndex;
    }]];
}

@end
