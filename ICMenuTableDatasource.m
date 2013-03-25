//
//  ICMenuTableDatasource.m
//  ModalGroupContacts
//
//  Created by marco on 13-3-12.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ICMenuTableDatasource.h"
#import "ICMenuTableSection.h"
#import "ReciverVo.h"

@implementation ICMenuTableDatasource

-(id)initWithSections:(NSArray*)datas{
    self = [super init];
    if (self) {
        self.sections = [datas mutableCopy];
    }
    return self;
}

-(void)dealloc{
    [_sections release];
    [super dealloc];
}

#pragma mark - TableViewDataSource method.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ICMenuTableSection* groupSection = [self.sections objectAtIndex:section];
    return groupSection.numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ICMenuTableSection* aGroup = [self.sections objectAtIndex:indexPath.section];
    UITableViewCell* cellForSectionRow = [aGroup cellForRow:indexPath.row];
    return cellForSectionRow;
}
@end

#import "MenuSectionReciverCell.h"
#import "ReciverVo.h"

@implementation ICMenuTableDatasource(DemoDataProvider)
+(ICMenuTableDatasource*)createDemoSections:(UITableView*)tableview{
    NSArray* demoData = [Reciver getDemoDatas];
    NSMutableArray* sections = [NSMutableArray array];
    [demoData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ICMenuTableSection* agroup = [[ICMenuTableSection alloc] initWithTableView:tableview sectionIdx:idx contentCellClz:[MenuSectionReciverCell class] titleCellClz:[MenuSectionReciverCell class]];
        agroup.titleData = obj;
        agroup.contentDatas = ((Reciver*)obj).memberList;
        [sections addObject:agroup];
        [agroup release];
    }];
    ICMenuTableDatasource* result = [[[ICMenuTableDatasource alloc] initWithSections:sections] autorelease];
    return result;
}
@end




