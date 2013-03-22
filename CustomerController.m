//
//  CustomerController.m
//  superTabNavigator
//
//  Created by marco on 13-1-31.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "CustomerController.h"
#import "DemoVo.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomerController ()
{
    UILabel* _labContent;
    UIButton* _btnChangeContent;
}
@property(nonatomic, readonly)UILabel* labContent;
@property(nonatomic, readonly)UIButton* btnChangeContent;
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

-(void)dealloc{
    [_labContent release];
    [_btnChangeContent release];
    [super dealloc];
}

-(void)loadView
{
    [super loadView];
    
    [self.view.layer setCornerRadius: 5.0];
    [self.view setClipsToBounds:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    
    UIImage* backgroundImg = [UIImage imageNamed:[self getDemoVo].img];
    [self.navigateBar setBackgroundImage:backgroundImg forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    self.labContent.text = [NSString stringWithFormat:@"%@", [NSDate date]];
    [self.btnChangeContent addTarget:self action:@selector(updateContent) forControlEvents:UIControlEventTouchUpInside];
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

-(UILabel*)labContent{
    if(!_labContent){
        _labContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 260, 16)];
        _labContent.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_labContent];
    }
    return _labContent;
}

-(UIButton*)btnChangeContent{
    if (!_btnChangeContent) {
        _btnChangeContent = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_btnChangeContent setTitle:@"更新事件" forState:UIControlStateNormal];
        _btnChangeContent.frame = CGRectMake(225, 70, 0, 0);
        [_btnChangeContent sizeToFit];
        [self.view addSubview:_btnChangeContent];
    }
    return _btnChangeContent;
}

-(void)updateContent{
    self.labContent.text = [NSString stringWithFormat:@"%@", [NSDate date]];
}

-(UINavigationBar*)navigateBar{
    if (!_navigateBar) {
        _navigateBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [self.view addSubview:_navigateBar];
    }
    return _navigateBar;
}

-(UIView*)gestureRecognizerTarget{
    return self.navigateBar;
}
@end
