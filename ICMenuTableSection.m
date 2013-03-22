//
//  ICMenuTableSection.m
//  ModalGroupContacts
//
//  Created by marco on 13-3-12.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ICMenuTableSection.h"

@implementation ICMenuTableSection

#pragma mark - private

- (NSArray*) getContentRowIndexPaths{
    NSMutableArray* updateRows = [NSMutableArray array];
    for (NSUInteger i = 1; i < self.contentNumberOfRow + 1; i++){
        [updateRows addObject:[NSIndexPath indexPathForRow:i inSection:self.sectionIndex]];
    }
    return updateRows;
}

- (UITableViewCell *) contentCellForRow:(NSUInteger)row{
    NSString* contentCellIdentifier = [NSString stringWithFormat:@"%d%@", self.sectionIndex, @"content"];
    UITableViewCell *cell = [self generatCellByCellIdentify:contentCellIdentifier cellClz:contentCellClz];
    [self processCell:cell cellData:[self.contentDatas objectAtIndex:row] sectionType:MenuSectionRowTypeContent];
	return cell;
}

- (UITableViewCell *) titleCellForSection{
    NSString* titleCellIdentifier = [NSString stringWithFormat:@"%d%@", self.sectionIndex, @"title"];
    UITableViewCell* cell = [self generatCellByCellIdentify:titleCellIdentifier cellClz:titleCellClz];
    [self processCell:cell cellData:self.titleData sectionType:MenuSectionRowTypeTitle];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (UITableViewCell*) generatCellByCellIdentify:(NSString*)identify cellClz:(Class)clz{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil && clz != nil)
        cell = [[[clz alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    return cell;
}

- (void) processCell:(UITableViewCell*)cell cellData:(NSObject*)data sectionType:(MenuSectionRowType)type{
    if ([cell respondsToSelector:@selector(setObject:)])
        [cell performSelector:@selector(setObject:) withObject:data];
    if ([cell respondsToSelector:@selector(setSectionTypeForRow:)])
        [cell performSelector:@selector(setSectionTypeForRow:) withObject:(id)type];
}

-(void) updateAccessoryViewOnCell{}

#pragma mark - public

-(void)dealloc{
    [_contentDatas release];
    [_titleData release];
    [super dealloc];
}

- (id) initWithTableView:(UITableView*)tbView
              sectionIdx:(NSUInteger)index contentCellClz:(Class)cclz titleCellClz:(Class)tclz{
    if ((self = [super init])){
        _sectionIndex = index;
        contentCellClz = cclz;
        titleCellClz = tclz;
        self.tableView = tbView;
        self.open = NO;
    }
    return self;
}

- (void) openSection{
    if (_open == NO){
        _open = YES;
        [self updateAccessoryViewOnCell];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[self getContentRowIndexPaths] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
}

- (void) closeSection{
    if (_open == YES){
        _open = NO;
        [self updateAccessoryViewOnCell];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[self getContentRowIndexPaths] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
}

- (void) reverseSection{
    _open ? [self closeSection] : [self openSection];
}

- (UITableViewCell *) cellForRow:(NSUInteger)row{
	UITableViewCell* cell = row == 0 ? [self titleCellForSection] : [self contentCellForRow:row - 1];
    return cell;
}

- (NSUInteger) contentNumberOfRow{
    return _contentDatas!=nil ? _contentDatas.count : 0;
}

- (NSUInteger) numberOfRow {
    return (self.open) ? self.contentNumberOfRow + 1 : 1;
}
@end