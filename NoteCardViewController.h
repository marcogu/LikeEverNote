//
//  NoteCardViewController.h
//  superTabNavigator
//
//  Created by marco on 13-1-15.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ICNoteControllerProtocol.h"

#define kDefaultNavigationBarOverlap 0.90
#define kDefaultMinimizedScalingFactor 0.98
#define kDefaultVerticalOrigin 100
#define kDefaultNavigationControllerToolbarHeight 44

@interface NoteCardViewController : UIViewController<PreviewableControllerProtocol, ICNoteViewControllerDelegate>
{
    NSInteger totalCards;
}

@property (nonatomic, assign) id<NoteViewControllerDataSource> dataSource;
@property (nonatomic, assign) NSArray* controllerCards;
@property (nonatomic, assign) id<ICNoteViewControllerDelegate> delegate;

//-(CGFloat)scalingFactorForIndex:(int)index;
//-(CGFloat)defaultVerticalOriginForIndex:(int)index;
//@property(nonatomic, retain)UIView* view;
@end
