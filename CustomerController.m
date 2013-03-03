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

static int intanceCount = 0;
// if use nib this conttruct method will be invoke.
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self myInit];
    NSLog(@"customerController: initWithNibName");
    return self;
}

// if use storyboard this construct method will be invoke
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self myInit];
    NSLog(@"customerController: initWithCoder");
    return self;
}

-(id)init{
    self = [super init];
    [self myInit];
    NSLog(@"customerController: init");
    return self;
}

-(void)myInit{
    idx = intanceCount;
    intanceCount ++;
    demovos = [DemoVo createTestData];
}

-(void)loadView
{
    [super loadView];
    [self navigateBar];
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

-(void)toRootTestClickHandler{
    NSLog(@"btn touched");
    [self.navigationController popViewControllerAnimated:NO];
}

-(UINavigationBar*)navigateBar{
    if (!_navigateBar) {
        _navigateBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [self.view addSubview:_navigateBar];
        UIImage* backgroundImg = [UIImage imageNamed:[self getDemoVo].img];
        [_navigateBar setBackgroundImage:backgroundImg forBarMetrics:UIBarMetricsDefault];
        self.view.backgroundColor = [UIColor yellowColor];
    }
    return _navigateBar;
}

-(DemoVo*)getDemoVo{
    return [demovos objectAtIndex:idx];
}

+(UIImage*)getSnapshotImg
{
    return nil;
}


@end
