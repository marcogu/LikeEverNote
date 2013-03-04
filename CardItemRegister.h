//
//  CardItemRegister.h
//  superTabNavigator
//
//  Created by marco on 13-3-1.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "NoteController.h"

enum{
    OnBackGroundRelasePolicy,
    KeepLifePolicy,
    ReleaseOnMemeryWarring
};
typedef UInt32 SubViewInstancePolicy;

@interface CardItemRegister : NSObject
{
    UIViewController<NoteControllerProtocal>* _targetObject;
}
@property (nonatomic, assign) Class targetClass;
@property (nonatomic) int  policy;
@property (nonatomic, retain) NSObject* params;

-(UIViewController<NoteControllerProtocal>*)getViewCtrl;
-(void)validateOnBackground;
@end
