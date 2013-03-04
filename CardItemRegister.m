//
//  CardItemRegister.m
//  superTabNavigator
//
//  Created by marco on 13-3-1.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "CardItemRegister.h"
#import "NoteController.h"


@implementation CardItemRegister

-(void) dealloc{
    [_targetObject release];
    [super dealloc];
}

-(UIViewController<NoteControllerProtocal>*)getViewCtrl{
    if(!_targetObject)
    {
        _targetObject = [[_targetClass alloc] initWithNibName:nil bundle:nil];
        _targetObject.initParam = self.params;
    }
    return _targetObject;
}

-(void)validateOnBackground
{
    if (self.policy == OnBackGroundRelasePolicy && _targetObject)
    {
        [_targetObject release];
        _targetObject = nil;
    }
}

-(void)validateOnMemberWarring
{
    if (self.policy == ReleaseOnMemeryWarring && _targetObject)
    {
        [_targetObject release];
        _targetObject = nil;
    }
}

@end
