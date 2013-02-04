//
//  NoteCardDatasource.m
//  superTabNavigator
//
//  Created by marco on 13-1-17.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "NoteCardDatasource.h"
#import "DemoVo.h"
#import "CustomerController.h"

@implementation NoteCardDatasource

-(id)init
{
    self = [super init];
    self.dataSource = [DemoVo createTestData];
    return self;
}

-(void)dealloc
{
    [_dataSource release];
    [super dealloc];
}

- (UIViewController *)noteView:(UIViewController<PreviewableControllerProtocol>*)noteView viewControllerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* mainStoryBoardFileName = @"SampleMainStoryboard";
    NSString* viewInStoryboardId = @"TheSameAsSample";
    
    DemoVo* vo = [_dataSource objectAtIndex:indexPath.row];
    UIStoryboard * st = [UIStoryboard storyboardWithName:mainStoryBoardFileName bundle:nil];
    CustomerController* itemController = [st instantiateViewControllerWithIdentifier:viewInStoryboardId];
    itemController.info = vo;
    return itemController;
}

- (NSInteger)numberOfControllerCardsInNoteView:(UIViewController<PreviewableControllerProtocol>*) noteView
{
    return self.dataSource.count;
}

+(NoteCardDatasource*)getSampleInstance
{
    return [[[NoteCardDatasource alloc] init] autorelease];
}



@end
