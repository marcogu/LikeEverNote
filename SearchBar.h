//
//  SearchBar.h
//  ModalGroupContacts
//
//  Created by marco on 13-3-10.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class ModalGroupController;

@interface SearchBar : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UILabel* _titleLabel;
    NSMutableArray* _selectedItem;
}
@property(nonatomic, readonly) UILabel* titleLabel;
@property(nonatomic, assign) ModalGroupController* superViewController;

- (void)shrinkActionPicker;
- (void)close;
- (void)open;
@end

//@interface SearchManager : NSObject
//-(SearchManager*)initWithDatas:(NSArray*)datas;
//@end
