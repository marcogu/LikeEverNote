//
//  NoteController.h
//  superTabNavigator
//
//  Created by marco on 13-3-4.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoteControllerProtocal <NSObject>
-(UIImage*)previewImageInCording;
-(UIView*)gestureRecognizerTarget;
@property(nonatomic, retain)NSObject* initParam;
@end

@interface NoteController : UIViewController<NoteControllerProtocal>
-(UIImage*)drawUIView:(UIView*)target;
@property(nonatomic, retain)NSObject* initParam;
@end
