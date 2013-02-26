//
//  ICCardItem.h
//  superTabNavigator
//
//  Created by marco on 13-2-4.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICNoteControllerProtocol.h"

@interface ICCardItem : UIView<CardViewProtocol>
{
    CGFloat originY;
    CGFloat scalingFactor;
    NSInteger index;
    UIImage* snapshot;
}

@property(nonatomic, retain) UIImageView* snapshotImg;
@property(nonatomic, retain) UIViewController<PreviewableControllerProtocol>* scheduleController;
@property (nonatomic, strong) NSObject<ICNoteViewControllerDelegate>* delegate;
@property (nonatomic) ICControllerCardState state;
@property (nonatomic) CGFloat panOriginOffset;
@property (nonatomic, retain) UIViewController* memberController;

-(id)initWithSnapshot:(UIImage*)snapshotImg scheduler:(UIViewController<PreviewableControllerProtocol>*)nvcontroller index:(NSInteger)idx;
-(void) setState:(ICControllerCardState)state animated:(BOOL) animated;

@end
