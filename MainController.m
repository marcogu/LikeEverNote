//
//  MainController.m
//  superTabNavigator
//
//  Created by marco on 13-1-14.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "MainController.h"
#import <QuartzCore/QuartzCore.h>

@interface MainController ()
@property(nonatomic, retain)UIView* testTabImg;
@end

@implementation MainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed:@"bar-mid.png"]
                                                  forBarMetrics: UIBarMetricsDefault];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(nearlessScreenShot)];
}

-(void)nearlessScreenShot
{
    NSLog(@"start");
    UIWindow* currentScrren = [[UIApplication sharedApplication].delegate window];
    UIImage* img = [self imageWithView:self.navigationController.view inScope:currentScrren.bounds];
    UIImageView* image = [[UIImageView alloc] initWithImage:img];
    image.frame = CGRectMake(0, 70, img.size.width, img.size.height);
    [self.view addSubview:image];
    NSLog(@"stop");
}

- (UIImage *)imageWithView:(UIView *)view inScope:(CGRect)scope
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(UIView*)testTabImg
{
    if (!_testTabImg)
    {
        _testTabImg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imgscrrentshot1.png"]] autorelease];
        _testTabImg.frame = CGRectMake(0, 0, 320, 480);
        [self.view addSubview:_testTabImg];
    }
    return _testTabImg;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void) didPerformPanGesture:(UIPanGestureRecognizer*) recognizer
{
    
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        self.testTabImg.frame = CGRectMake(self.testTabImg.frame.origin.x, 0, self.testTabImg.frame.size.width, self.testTabImg.frame.size.height);
    }
}

@end
