//
//  ModalGroupController.h
//  ModalGroupContacts
//
//  Created by marco on 13-3-12.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteController.h"

@class SearchBar;
@class ICRecipientPicker;

@interface ModalGroupController : UIViewController<NoteControllerProtocal>
@property(nonatomic, retain) SearchBar* titlBar;
@property(nonatomic, retain) UITableView* tableView;
@property(nonatomic, retain) NSMutableArray* selectedRecivers;
@property(nonatomic, readonly)ICRecipientPicker* picker;
@property(nonatomic, retain)NSObject* initParam;
@end
