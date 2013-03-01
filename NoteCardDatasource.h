//
//  NoteCardDatasource.h
//  superTabNavigator
//
//  Created by marco on 13-1-17.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ICNoteControllerProtocol.h"

enum{
    OnBackGroundRelasePolicy,
    KeepLifePolicy
};
typedef UInt32 SubViewInstancePolicy;

@class CardItemRegister;

@protocol SubViewControllerSupport <NSObject>
-(CardItemRegister*)registViewCtrl:(Class)vctrlClz viewPolicy:(SubViewInstancePolicy)policy;
-(CardItemRegister*)registViewCtrl:(Class)vctrlClz viewPolicy:(SubViewInstancePolicy)policy paramObj:(NSObject*)param;
@end

@interface NoteCardDatasource : NSObject<NoteViewControllerDataSource, SubViewControllerSupport>
@property(nonatomic, retain) NSMutableArray* dataSource;
- (NSInteger)numberOfControllerCardsInNoteView;
- (UIViewController *)noteView:(UIViewController<PreviewableControllerProtocol>*)noteView viewControllerForRowAtIndexPath:(NSIndexPath *)indexPath;

+(NoteCardDatasource*)getSampleInstance;
@end
