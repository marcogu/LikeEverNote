//
//  SelectorTableVIewDelegate.m
//  ModalGroupContacts
//
//  Created by marco on 13-3-13.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "SelectorTableViewDelegate.h"
#import "ICMenuTableDatasource.h"
#import "MenuSectionReciverCell.h"
#import "ICMenuTableSection.h"
#import "ICRecipientPicker.h"
#import "MenuSectionReciverCell.h"

@implementation SelectorTableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ICMenuTableSection* section = [self.ds.sections objectAtIndex:indexPath.section];
        [section reverseSection];
    }else{
        MenuSectionReciverCell* cell = (MenuSectionReciverCell*)[tableView cellForRowAtIndexPath:indexPath];
        NSObject<ICRecipientPickerDataSource>* pickerDataSource = ((ICRecipientPicker*)self.floatHeaderView).datasource;
        [pickerDataSource putItem:cell.object];
        [self showHeaderViewWithScrollView:tableView animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ICMenuTableSection* section = [self.ds.sections objectAtIndex:indexPath.section];
        [section reverseSection];
    }
}


@end
