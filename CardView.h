//
//  CardView.h
//  superTabNavigator
//
//  Created by marco on 13-1-14.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICNoteControllerProtocol.h"

@interface CardView : UIView<CardViewProtocol>
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

-(id) initWithNoteViewController: (UIViewController<PreviewableControllerProtocol>*) noteView navigationController:(UINavigationController*) navigationController index:(NSInteger) index;
@property(nonatomic, retain) UIImage* snapshot;
- (void) setState:(ICControllerCardState)state animated:(BOOL) animated;
@end
