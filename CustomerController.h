//
//  CustomerController.h
//  superTabNavigator
//
//  Created by marco on 13-1-31.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DemoVo;

@interface CustomerController : UIViewController
@property (nonatomic, strong) DemoVo* info;
@property(nonatomic, retain) UINavigationBar* navigateBar;

+(UIImage*)getSnapshotImg;
@end
