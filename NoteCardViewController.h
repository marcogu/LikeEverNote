//
//  NoteCardViewController.h
//  superTabNavigator
//
//  Created by marco on 13-1-15.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ICNoteControllerProtocol.h"

@protocol SubViewControllerSupport;

@interface NoteCardViewController : UIViewController<PreviewableControllerProtocol, ICNoteViewControllerDelegate>
{
    NSInteger totalCards;
}

@property (nonatomic, retain) NSObject<NoteViewControllerDataSource>* dataSource;
@property (nonatomic, assign) NSArray* controllerCards;
@property (nonatomic, assign) id<ICNoteViewControllerDelegate> delegate;

+(NoteCardViewController*)getCurrentInstance;
-(NSObject<SubViewControllerSupport>*)getViewCtrlRegister;
//-(CGFloat)scalingFactorForIndex:(int)index;
//-(CGFloat)defaultVerticalOriginForIndex:(int)index;
//@property(nonatomic, retain)UIView* view;
@end
