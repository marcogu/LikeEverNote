//
//  ICMenuTableSection.h
//  ModalGroupContacts
//
//  Created by marco on 13-3-12.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MenuSectionRowTypeTitle,
    MenuSectionRowTypeContent
} MenuSectionRowType;

@interface ICMenuTableSection : NSObject
{
    Class contentCellClz;
    Class titleCellClz;
}

@property (nonatomic, readonly) NSUInteger sectionIndex;
@property (nonatomic, retain) NSArray* contentDatas;
@property (nonatomic, retain) NSObject* titleData;
@property (nonatomic, readonly) NSUInteger contentNumberOfRow;
@property (nonatomic, readonly) NSUInteger numberOfRow;
@property (nonatomic, assign) UITableView* tableView;
@property (nonatomic, assign) BOOL open;

- (id) initWithTableView:(UITableView*)tableView
              sectionIdx:(NSUInteger)index contentCellClz:(Class)cclz titleCellClz:(Class)tclz;
- (void) openSection ;
- (void) closeSection ;
- (UITableViewCell *) cellForRow:(NSUInteger)row;
- (void) reverseSection;

@end
