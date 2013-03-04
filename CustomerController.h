//
//  CustomerController.h
//  superTabNavigator
//
//  Created by marco on 13-1-31.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "NoteController.h"

@class DemoVo;

@interface CustomerController : NoteController
@property (nonatomic, strong) DemoVo* info;
@property(nonatomic, retain) UINavigationBar* navigateBar;

+(UIImage*)getSnapshotImg;
@end
