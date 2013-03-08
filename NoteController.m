//
//  NoteController.m
//  superTabNavigator
//
//  Created by marco on 13-3-4.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "NoteController.h"
#import <QuartzCore/QuartzCore.h>

@interface NoteController ()

@end

@implementation NoteController

-(void)dealloc{
    [self.navigateBar release];
    [super dealloc];
}

-(UIImage*)previewImageInCording
{
    return [self drawUIView:self.view];
}

-(UIImage*)drawUIView:(UIView*)target
{
    UIGraphicsBeginImageContextWithOptions(target.bounds.size, target.opaque, 0.0);
    [target.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(UINavigationBar*)navigateBar{
    if (!_navigateBar) {
        _navigateBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [self.view addSubview:_navigateBar];
    }
    return _navigateBar;
}

-(UIView*)gestureRecognizerTarget
{
    return self.navigateBar;
}


@end
