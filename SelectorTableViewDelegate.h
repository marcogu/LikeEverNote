//
//  SelectorTableVIewDelegate.h
//  ModalGroupContacts
//
//  Created by marco on 13-3-13.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "FullScreenScrollViewDelegate.h"

@class ICMenuTableDatasource;
@interface SelectorTableViewDelegate : FullScreenScrollViewDelegate<UITableViewDelegate>
@property(nonatomic, assign)ICMenuTableDatasource* ds;
@end
