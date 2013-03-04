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

-(UIView*)gestureRecognizerTarget
{
    return self.navigationController.navigationBar;
}


@end
