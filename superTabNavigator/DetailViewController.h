//
//  DetailViewController.h
//  superTabNavigator
//
//  Created by marco on 13-1-14.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
