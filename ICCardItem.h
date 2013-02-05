//
//  ICCardItem.h
//  superTabNavigator
//
//  Created by marco on 13-2-4.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICNoteControllerProtocol.h"

//#define kDefaultAnimationDuration 0.3
//#define kDefaultMaximizedScalingFactor 1.00
//#define kDefaultShadowOffset CGSizeMake(0, -5)
//#define kDefaultCornerRadius 5.0
//#define kDefaultShadowOpacity 0.60
//#define kDefaultShadowRadius 7.0
//#define kDefaultShadowColor [UIColor blackColor]
//#define kDefaultShadowEnabled YES
//
//enum {
//    ICControllerCardStateHiddenBottom,    //Card is hidden off screen (Below bottom of visible area)
//    ICControllerCardStateHiddenTop,       //Card is hidden off screen (At top of visible area)
//    ICControllerCardStateDefault,         //Default location for the card
//    ICControllerCardStateFullScreen       //Highlighted location for the card
//};
//typedef UInt32 ICControllerCardState;

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

-(id)initWithSnapshot:(UIImage*)snapshotImg scheduler:(UIViewController<PreviewableControllerProtocol>*)nvcontroller index:(NSInteger)idx;
-(void) setState:(ICControllerCardState)state animated:(BOOL) animated;

@end
