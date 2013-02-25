//
//  ICSuperTabController.m
//  superTabNavigator
//
//  Created by marco on 13-2-8.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ICSuperTabController.h"
#import "ICCardItem.h"


#define defaultCardViewClz [ICCardItem class];

@interface ICSuperTabController ()

@end

@implementation ICSuperTabController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cardViewClz = defaultCardViewClz;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadData
{
    int totalCards = [self.dataSource numberOfControllerCardsInNoteView];
//    NSMutableArray* nvcontrollers = [NSMutableArray array];
    for (int count = 0; count < totalCards; count++)
    {
//        NSObject<CardViewProtocol>* cdContainer = [self createNVCByDataIdx:count];
//        [nvcontrollers addObject:cdContainer];
//        [cdContainer release];
//        
//        [self didMoveToParentViewController:self];
    }
//    self.controllerCards = nvcontrollers;
}

//-(NSObject<CardViewProtocol>*)createNVCByDataIdx:(int)dataIndex
//{
//    UIViewController* vc = [self.dataSource noteView:self viewControllerForRowAtIndexPath:[NSIndexPath indexPathForRow:dataIndex inSection:0]];
//    UINavigationController* nvgcontroller = [[UINavigationController alloc] initWithRootViewController:vc];
//                                                                                  index:dataIndex];
//    UIImage* snapshot = [self drawUIView:vc.view];
    
//    NSObject<CardViewProtocol>* cdContainer = [_cardViewClz alloc];
//    [cdContainer initWithSnapshot:nil scheduler:self index:0];
    
//    [[ICCardItem alloc] initWithSnapshot:snapshot scheduler:self index:dataIndex];
    
//    cdContainer.delegate = self;
//    [self addChildViewController:nvgcontroller];
//    [nvgcontroller release];
//    return cdContainer;
//}

-(UIImage*)drawUIView:(UIView*)target
{
    UIGraphicsBeginImageContextWithOptions(target.bounds.size, target.opaque, 0.0);
    [target.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
