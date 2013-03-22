//
//  SampleAppDelgate.m
//  superTabNavigator
//
//  Created by marco on 13-1-14.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "SampleAppDelgate.h"
#import "NoteCardViewController.h"
#import "NoteCardDatasource.h"
#import "CustomerController.h"
#import "ModalGroupController.h"
#import "DemoVo.h"


@implementation SampleAppDelgate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    NSObject<SubViewControllerSupport>* cardController = [[NoteCardViewController getCurrentInstance] getViewCtrlRegister];
    
    [cardController registViewCtrl:[CustomerController class] viewPolicy:OnBackGroundRelasePolicy paramObj:[DemoVo create:@"premium-header-mid-skinny.png" title:@"Go Premium"]];
    
    [cardController registViewCtrl:[CustomerController class] viewPolicy:OnBackGroundRelasePolicy paramObj:[DemoVo create:@"bar-mid.png" title:@"Places"]];
    
    [cardController registViewCtrl:[CustomerController class] viewPolicy:OnBackGroundRelasePolicy paramObj:[DemoVo create:@"bar-mid.png" title:@"Tags"]];
    
    [cardController registViewCtrl:[CustomerController class] viewPolicy:OnBackGroundRelasePolicy paramObj:[DemoVo create:@"bar-mid.png" title:@"Notebooks"]];
    
//    ModalGroupController* _targetController = [[ModalGroupController alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:_targetController animated:YES];
    [cardController registViewCtrl:[ModalGroupController class] viewPolicy:OnBackGroundRelasePolicy];
    
    [cardController registViewCtrl:[CustomerController class] viewPolicy:OnBackGroundRelasePolicy paramObj:[DemoVo create:@"bar-mid.png" title:@"temp"]];

    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

@end
