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


@implementation SampleAppDelgate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    NSObject<SubViewControllerSupport>* cardController = [[NoteCardViewController getCurrentInstance] getViewCtrlRegister];
    
    [cardController registViewCtrl:[CustomerController class] viewPolicy:OnBackGroundRelasePolicy];
    [cardController registViewCtrl:[CustomerController class] viewPolicy:OnBackGroundRelasePolicy];
//    [cardController registViewCtrl:[CustomerController class] viewPolicy:OnBackGroundRelasePolicy];
//    [cardController registViewCtrl:[CustomerController class] viewPolicy:OnBackGroundRelasePolicy];
//    [cardController registViewCtrl:[CustomerController class] viewPolicy:OnBackGroundRelasePolicy];
    
//    cardController.re
    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

@end
