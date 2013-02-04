//
//  CustomerController.m
//  superTabNavigator
//
//  Created by marco on 13-1-31.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "CustomerController.h"
#import "DemoVo.h"

@interface CustomerController ()

@end

@implementation CustomerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_info)
    {
        UIImage* backgroundImg = [UIImage imageNamed:self.info.img];
        [self.navigationController.navigationBar setBackgroundImage:backgroundImg forBarMetrics:UIBarMetricsDefault];
        [self.navigationController setTitle:_info.title];
    }

}


@end
