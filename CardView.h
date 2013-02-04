//
//  CardView.h
//  superTabNavigator
//
//  Created by marco on 13-1-14.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICNoteControllerProtocol.h"

#define kDefaultAnimationDuration 0.3
#define kDefaultMaximizedScalingFactor 1.00
#define kDefaultShadowOffset CGSizeMake(0, -5)
#define kDefaultCornerRadius 5.0
#define kDefaultShadowOpacity 0.60
#define kDefaultShadowRadius 7.0
#define kDefaultShadowColor [UIColor blackColor]
#define kDefaultShadowEnabled YES

enum {
    ICControllerCardStateHiddenBottom,    //Card is hidden off screen (Below bottom of visible area)
    ICControllerCardStateHiddenTop,       //Card is hidden off screen (At top of visible area)
    ICControllerCardStateDefault,         //Default location for the card
    ICControllerCardStateFullScreen       //Highlighted location for the card
};
typedef UInt32 ICControllerCardState;

@interface CardView : UIView
{
@private
    CGFloat originY;
    CGFloat scalingFactor;
    NSInteger index;
}

@property (nonatomic, strong) UINavigationController* navigationController;
@property (nonatomic, strong) UIViewController<PreviewableControllerProtocol>* noteViewController;
@property (nonatomic) ICControllerCardState state;
@property (nonatomic) CGFloat panOriginOffset;
@property (nonatomic, strong) NSObject<ICNoteViewControllerDelegate>* delegate;

// old version
-(id) initWithNoteViewController: (UIViewController<PreviewableControllerProtocol>*) noteView navigationController:(UINavigationController*) navigationController index:(NSInteger) index;
// my version
-(id)initWithControlSnapshot:(UIImage*)snapshotImg scheduler:(id<PreviewableControllerProtocol>)nvcontroller index:(NSInteger)idx;

@property(nonatomic, retain) UIImage* snapshot;

- (void) setState:(ICControllerCardState)state animated:(BOOL) animated;

@end
