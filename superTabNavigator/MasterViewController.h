//
//  MasterViewController.h
//  superTabNavigator
//
//  Created by marco on 13-1-14.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
