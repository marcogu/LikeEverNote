//
//  NoteCardViewController.m
//  superTabNavigator
//
//  Created by marco on 13-1-15.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "NoteCardViewController.h"
#import "NoteCardDatasource.h"
#import "ICNoteControllerProtocol.h"

@interface NoteCardViewController ()
@end

@implementation NoteCardViewController

static NoteCardViewController* _currentInstatnce;

+(NoteCardViewController*)getCurrentInstance
{
    return _currentInstatnce;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    _currentInstatnce = self;
    self.dataSource = [NoteCardDatasource getSampleInstance];
    return self;
}

-(void)dealloc{
    [_dataSource release];
    [super dealloc];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void) viewDidLoad
{
    [self reloadData];
    [super viewDidLoad];
    [self reloadInputViews];
}

#pragma mark - private method

- (void) reloadData
{
    totalCards = [self.dataSource numberOfControllerCardsInNoteView];
    NSMutableArray* nvcontrollers = [NSMutableArray array];
    for (int count = 0; count < totalCards; count++)
        [nvcontrollers addObject:[self.dataSource cardForRowAtIdxPath:count rootCtrl:self]];
    self.controllerCards = nvcontrollers;
    
}

- (void) reloadInputViews
{
    [super reloadInputViews];
    //TODO: do clear logic
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
/**/
-(void) controllerCard:(UIView<CardViewProtocol>*)card didUpdatePanPercentage:(CGFloat) percentage{
    if (card.state == ICControllerCardStateFullScreen)
    {
        for (int i=[card getCardIndex]; i<self.dataSource.numberOfControllerCardsInNoteView; i++) {
//            UIView<CardViewProtocol>* crutCard = [self.dataSource cardForRowAtIdxPath:i rootCtrl:self];
//            CGFloat yCoordinate = (CGFloat) crutCard.origin.y * [card percentageDistanceTravelled];
//            [crutCard setYCoordinate:yCoordinate];
        }
    }
    else if(card.state == ICControllerCardStateDefault)
    {
//        for (int i=[card getCardIndex]; i>=0; i--) {
        for (int i=[card getCardIndex]+1; i<self.dataSource.numberOfControllerCardsInNoteView; i++) {
            UIView<CardViewProtocol>* crutCard = [self.dataSource cardForRowAtIdxPath:i rootCtrl:self];
            CGFloat deltaDistance = card.frame.origin.y - card.origin.y;
            CGFloat yCoordinate = crutCard.origin.y + deltaDistance;
            [crutCard setYCoordinate: yCoordinate];
        }
    }
}

//这个方法提供其他非当前card动画。暂时忽略
-(void) controllerCard:(NSObject<CardViewProtocol>*)controllerCard didChangeToDisplayState:(ICControllerCardState) toState fromDisplayState:(ICControllerCardState) fromState {
    return;
    /**
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
     for (NSObject<CardViewProtocol>* cardBelow in [self controllerCardBelowCard: controllerCard]) {
     [cardBelow setState:ICControllerCardStateDefault animated:YES];
     }
     }
     
     //Notify the delegate of the change
     if ([self.delegate respondsToSelector:@selector(controllerCard:didChangeToDisplayState:fromDisplayState:)]) {
     [self.delegate controllerCard:controllerCard didChangeToState:toState fromState:fromState];
     }
     */
}

/*
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
 
 */

-(NSObject<SubViewControllerSupport>*)getViewCtrlRegister
{
    if (self.dataSource)
        return (NSObject<SubViewControllerSupport>*)self.dataSource;
    return nil;
}

@end
