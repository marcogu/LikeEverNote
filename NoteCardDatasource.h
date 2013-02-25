//
//  NoteCardDatasource.h
//  superTabNavigator
//
//  Created by marco on 13-1-17.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ICNoteControllerProtocol.h"

@interface NoteCardDatasource : NSObject<NoteViewControllerDataSource>
@property(nonatomic, retain) NSArray* dataSource;
- (NSInteger)numberOfControllerCardsInNoteView;
- (UIViewController *)noteView:(UIViewController<PreviewableControllerProtocol>*)noteView viewControllerForRowAtIndexPath:(NSIndexPath *)indexPath;

+(NoteCardDatasource*)getSampleInstance;
@end
