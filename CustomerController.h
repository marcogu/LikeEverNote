//
//  CustomerController.h
//  superTabNavigator
//
//  Created by marco on 13-1-31.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "NoteController.h"

@class DemoVo;
@interface CustomerController : UIViewController<NoteControllerProtocal>
@property(nonatomic, retain) UINavigationBar* navigateBar;
@property(nonatomic, retain)NSObject* initParam;
@end
