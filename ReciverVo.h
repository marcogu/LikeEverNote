//
//  MemberVo.h
//  ModalGroupContacts
//
//  Created by marco on 13-3-12.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reciver : NSObject

@property(nonatomic)BOOL isGroup;
@property(nonatomic, retain)NSString* avatar;
@property(nonatomic, retain)NSString* reciverName;
@property(nonatomic, retain)NSNumber* r;
@property(nonatomic, retain)NSNumber* g;
@property(nonatomic, retain)NSNumber* b;
@property(nonatomic, retain)NSNumber* reciverId;
@property(nonatomic, retain)NSString* groupType;
@property(nonatomic, retain)NSString* otherInfo;

@property(nonatomic, retain)NSMutableArray *memberList;

+(NSArray*)getDemoDatas;
@end
