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

-(void)loadView
{
    [super loadView];
    UINavigationBar* myBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [self.view addSubview:myBar];
    UIImage* backgroundImg = [UIImage imageNamed:self.info.img];
    [myBar setBackgroundImage:backgroundImg forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor redColor];
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    if (_info)
//    {
//        UIImage* backgroundImg = [UIImage imageNamed:self.info.img];
//        [self.navigationController.navigationBar setBackgroundImage:backgroundImg forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController setTitle:_info.title];
//    }
//}

+(UIImage*)getSnapshotImg
{
    return nil;
}


@end
