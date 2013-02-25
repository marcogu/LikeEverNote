//
//  ICSuperTabController.h
//  superTabNavigator
//
//  Created by marco on 13-2-8.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ICNoteControllerProtocol.h"

@interface ICSuperTabController : UIViewController

@property (nonatomic, assign) id<NoteViewControllerDataSource> dataSource;
@property (nonatomic, assign) Class cardViewClz;
@end
