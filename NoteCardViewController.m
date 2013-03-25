//
//  NoteCardViewController.m
//  superTabNavigator
//
//  Created by marco on 13-1-15.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
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
    [self.view.layer setCornerRadius: 5.0];
    [self.view setClipsToBounds:YES];
//    [self.view setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-dark-gray-tex.png"]]];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
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
//    CGFloat result = powf(kDefaultMinimizedScalingFactor, (totalCards - index));
//    NSLog(@"scale = %f", result);
//    return result;
    // my version
    return 0.95;
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
    UIView<CardViewProtocol>* crutCard = nil;
    if (card.state == ICControllerCardStateFullScreen)
    {
        for (int i=[card getCardIndex]; i>=0; i--) {
            crutCard = [self.dataSource cardForRowAtIdxPath:i rootCtrl:self];
            CGFloat yCoordinate = (CGFloat) crutCard.origin.y * [card percentageDistanceTravelled];
            [crutCard setYCoordinate:yCoordinate];
        }
    }
    else if(card.state == ICControllerCardStateDefault)
    {
        for (int i=[card getCardIndex]+1; i<self.dataSource.numberOfControllerCardsInNoteView; i++) {
            crutCard = [self.dataSource cardForRowAtIdxPath:i rootCtrl:self];
            CGFloat deltaDistance = card.frame.origin.y - card.origin.y;
            CGFloat yCoordinate = crutCard.origin.y + deltaDistance;
            [crutCard setYCoordinate: yCoordinate];
        }
    }
}

//这个方法提供其他非当前card动画。暂时忽略
-(void) controllerCard:(NSObject<CardViewProtocol>*)card didChangeToState:(int)toState fromState:(int) fromState {
    UIView<CardViewProtocol>* tempCard = nil;
    if (fromState == ICControllerCardStateDefault && toState == ICControllerCardStateFullScreen)
    {
        for (int i=[card getCardIndex]-1; i>=0; i--)
        {    
            tempCard = [self.dataSource cardForRowAtIdxPath:i rootCtrl:self];
            [tempCard setState:ICControllerCardStateHiddenTop animated:YES];
        }
        for (int i=[card getCardIndex]+1; i<self.dataSource.numberOfControllerCardsInNoteView; i++)
        {
            tempCard = [self.dataSource cardForRowAtIdxPath:i rootCtrl:self];
            [tempCard setState:ICControllerCardStateHiddenBottom animated:YES];
        }
    }
    else if (fromState == ICControllerCardStateFullScreen && toState == ICControllerCardStateDefault)
    {
        for (int i=[card getCardIndex]-1; i>=0; i--)
        {
            tempCard = [self.dataSource cardForRowAtIdxPath:i rootCtrl:self];
            [tempCard setState:ICControllerCardStateDefault animated:YES];
        }
        for (int i=[card getCardIndex]+1; i<self.dataSource.numberOfControllerCardsInNoteView; i++)
        {
            tempCard = [self.dataSource cardForRowAtIdxPath:i rootCtrl:self];
            [tempCard setState:ICControllerCardStateHiddenBottom animated:NO];
            [tempCard setState:ICControllerCardStateDefault animated:YES];
        }
    }
    else if (fromState == ICControllerCardStateDefault && toState == ICControllerCardStateDefault)
    {
        for (int i=[card getCardIndex]+1; i<self.dataSource.numberOfControllerCardsInNoteView; i++)
        {
            tempCard = [self.dataSource cardForRowAtIdxPath:i rootCtrl:self];
            [tempCard setState:ICControllerCardStateDefault animated:YES];
        }
    }
    return;
}

-(NSObject<SubViewControllerSupport>*)getViewCtrlRegister
{
    if (self.dataSource)
        return (NSObject<SubViewControllerSupport>*)self.dataSource;
    return nil;
}

@end
