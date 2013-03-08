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
    NSMutableArray* demovos;
    int idx;
}
@end

@implementation CustomerController

// if use nib this conttruct method will be invoke.
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"customerController: initWithNibName");
    return self;
}

// if use storyboard this construct method will be invoke
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    NSLog(@"customerController: initWithCoder");
    return self;
}

-(id)init{
    self = [super init];
    NSLog(@"customerController: init");
    return self;
}

-(void)loadView
{
    [super loadView];
    UIImage* backgroundImg = [UIImage imageNamed:[self getDemoVo].img];
    [self.navigateBar setBackgroundImage:backgroundImg forBarMetrics:UIBarMetricsDefault];
}

-(DemoVo*)getDemoVo{
    return (DemoVo*)self.initParam;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"member controller view did load");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"member controller will appear");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"member controller did appear");
}

-(void) viewWillUnload{
    [super viewWillUnload];
    NSLog(@"member controller view will unload");
}

-(void) viewDidUnload{
    [super viewDidUnload];
    NSLog(@"member controller view did unload");
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"member controller view will disappear");
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"member controller view did disappear");
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    NSLog(@"member controller view will layout sub views");
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"member controller view did layout sub views");
}
@end
