//
//  NoteCardDatasource.m
//  superTabNavigator
//
//  Created by marco on 13-1-17.
//  Copyright (c) 2013年 marco. All rights reserved.
//


#import "NoteCardDatasource.h"
#import "DemoVo.h"
#import "ICCardItem.h"
#import "CardItemRegister.h"

@implementation NoteCardDatasource

-(id)init
{
    self = [super init];
    self.dataSource = [[NSMutableArray array] retain];
    return self;
}

-(void)dealloc
{
    [_dataSource release];
    [super dealloc];
}

// will depracated
- (UIViewController *)noteView:(UIViewController<PreviewableControllerProtocol>*)noteView viewControllerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardItemRegister* rg = [_dataSource objectAtIndex:indexPath.row];
    return [self getViewCtrlByRegister:rg];
}

- (NSInteger)numberOfControllerCardsInNoteView
{
    return self.dataSource.count;
}

+(NoteCardDatasource*)getSampleInstance
{
    return [[[NoteCardDatasource alloc] init] autorelease];
}

- (UIView<CardViewProtocol>*)cardForRowAtIdxPath:(NSInteger)idx rootCtrl:(UIViewController<PreviewableControllerProtocol>*)nvcontroller
{
    CardItemRegister* rg = [_dataSource objectAtIndex:idx];
    UIView<CardViewProtocol>* cdContainer = [[[ICCardItem alloc] initWithItem:rg scheduler:nvcontroller index:idx] autorelease];
    cdContainer.cardItem = rg;
    return cdContainer;
}

#pragma mark - SubViewControllerSupport
-(CardItemRegister*)registViewCtrl:(Class)vctrlClz viewPolicy:(SubViewInstancePolicy)policy
{
    CardItemRegister* carditem = [[CardItemRegister alloc] init];
    carditem.targetClass = vctrlClz;
    carditem.policy = policy;
    [self.dataSource addObject:carditem];
    [carditem release];
    return carditem;
}

-(CardItemRegister*)registViewCtrl:(Class)vctrlClz viewPolicy:(SubViewInstancePolicy)policy paramObj:(NSObject*)param
{
    CardItemRegister* item = [self registViewCtrl:vctrlClz viewPolicy:policy];
    item.params = param;
    return item;
}

#pragma mark - private
// sample method
-(UIViewController*)getViewControllerInstanceByStoryBoard:(DemoVo*)args
{
    NSString* mainStoryBoardFileName = @"SampleMainStoryboard";
    NSString* viewInStoryboardId = @"TheSameAsSample";
    
    UIStoryboard * st = [UIStoryboard storyboardWithName:mainStoryBoardFileName bundle:nil];
    UIViewController* itemController = [st instantiateViewControllerWithIdentifier:viewInStoryboardId];
    return itemController;
}

// real logic
-(UIViewController*)getViewCtrlByRegister:(CardItemRegister*)rg
{
    if (rg.policy == KeepLifePolicy && rg.getViewCtrl) {
        return rg.getViewCtrl;
    }
    UIViewController* viewCtrl = [[[rg.targetClass alloc] initWithNibName:nil bundle:nil] autorelease];
    return viewCtrl;
}

@end
