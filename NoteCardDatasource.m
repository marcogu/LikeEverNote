//
//  NoteCardDatasource.m
//  superTabNavigator
//
//  Created by marco on 13-1-17.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "NoteCardDatasource.h"
#import "DemoVo.h"

#import "CardItemRegister.h"

@implementation NoteCardDatasource

-(id)init
{
    self = [super init];
    // sample version
    self.dataSource = [DemoVo createTestData];
    // TODO: real logic
//    self.dataSource = [[NSMutableArray array] retain];
    return self;
}

-(void)dealloc
{
    [_dataSource release];
    [super dealloc];
}

- (UIViewController *)noteView:(UIViewController<PreviewableControllerProtocol>*)noteView viewControllerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //sample:
    DemoVo* vo = [_dataSource objectAtIndex:indexPath.row];
    return [self getViewControllerInstanceByStoryBoard: vo];
    //real
//    CardItemRegister* rg = [_dataSource objectAtIndex:indexPath.row];
//    return [self getViewCtrlByRegister:rg];
}

- (NSInteger)numberOfControllerCardsInNoteView
{
    return self.dataSource.count;
}

+(NoteCardDatasource*)getSampleInstance
{
    return [[[NoteCardDatasource alloc] init] autorelease];
}

- (UIViewController*)topViewController
{
    return nil;
}

#pragma mark - SubViewControllerSupport
-(CardItemRegister*)registViewCtrl:(Class)vctrlClz viewPolicy:(SubViewInstancePolicy)policy
{
    CardItemRegister* carditem = [[CardItemRegister alloc] init];
    carditem.targetClass = vctrlClz;
    carditem.policy = policy;
    [self.dataSource addObject:carditem];
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
    if (rg.policy == KeepLifePolicy && rg.targetObject) {
        return rg.targetObject;
    }
    UIViewController* viewCtrl = [rg.targetClass alloc];
    if ([viewCtrl respondsToSelector:@selector(initWithNavigatorURL:query:)]) {

    }else{
        [viewCtrl initWithNibName:nil bundle:nil];
    }
//    rg.targetObject = viewCtrl;
    return [viewCtrl autorelease];
}

@end
