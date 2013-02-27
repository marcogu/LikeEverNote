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
{
    UIButton* _btnTest;
}
@property(nonatomic, readonly)UIButton* btnTestPop;
@end

@implementation CustomerController

-(void)loadView
{
    [super loadView];
    [self navigateBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"member controller will appear");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"member controller did appear");
    [self btnTestPop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"member controller view did load");
}

-(void)toRootTestClickHandler{
    NSLog(@"btn touched");
    [self.navigationController popViewControllerAnimated:NO];
}

-(UINavigationBar*)navigateBar{
    if (!_navigateBar) {
        _navigateBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [self.view addSubview:_navigateBar];
        UIImage* backgroundImg = [UIImage imageNamed:self.info.img];
        [_navigateBar setBackgroundImage:backgroundImg forBarMetrics:UIBarMetricsDefault];
        self.view.backgroundColor = [UIColor yellowColor];
    }
    return _navigateBar;
}

// create a test button
-(UIButton*)btnTestPop
{
    if(!_btnTest)
    {
        _btnTest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _btnTest.frame = CGRectMake(20, 70, 120, 35);
        [_btnTest addTarget:self action:@selector(toRootTestClickHandler) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_btnTest];
    }
    return _btnTest;
}

+(UIImage*)getSnapshotImg
{
    return nil;
}


@end
