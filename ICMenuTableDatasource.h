//
//  ICMenuTableDatasource.h
//  ModalGroupContacts
//
//  Created by marco on 13-3-12.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICMenuTableDatasource : NSObject<UITableViewDataSource>
@property(nonatomic, retain)NSMutableArray* sections;
-(id)initWithSections:(NSArray*)datas;
@end

@interface ICMenuTableDatasource(DemoDataProvider)
+(ICMenuTableDatasource*)createDemoSections:(UITableView*)tableview;
@end