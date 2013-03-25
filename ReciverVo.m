//
//  MemberVo.m
//  ModalGroupContacts
//
//  Created by marco on 13-3-12.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ReciverVo.h"

@implementation Reciver

-(void)dealloc{
    [_reciverId release];
    [_reciverName release];
    [_memberList release];
    [_avatar release];
    [_otherInfo release];
    [_groupType release];
    [_b release];
    [_g release];
    [_r release];
    [super dealloc];
}


+(NSArray*)getDemoDatas{
    Reciver* member = nil;
    
    Reciver* group1 = [[Reciver alloc] init];
    group1.r = [NSNumber numberWithInt:44];
    group1.g = [NSNumber numberWithInt:111];
    group1.b = [NSNumber numberWithInt:146];
    group1.reciverName = @"所有教师";
    group1.groupType = @"GroupNormal";
    group1.isGroup = YES;
    group1.memberList = [NSMutableArray array];
    
    Reciver* group2 = [[Reciver alloc] init];
    group2.r = [NSNumber numberWithInt:240];
    group2.g = [NSNumber numberWithInt:131];
    group2.b = [NSNumber numberWithInt:0];
    group2.reciverName = @"白雪公主和七个小矮人";
    group2.groupType = @"GroupNormal";
    group2.isGroup = YES;
    group2.memberList = [NSMutableArray array];
    
    member = [[Reciver alloc] init];
    member.avatar = @"http://oss.iclass.com/iclassbaby/50_50/1362030557582nzqzr.jpg";
    member.reciverName = @"iclass";
    member.reciverId = [NSNumber numberWithInt:1419];
    member.otherInfo = @"Teacher_1419_iclass";
    [group1.memberList addObject:member];
    [member release];

    member = [[Reciver alloc] init];
    member.avatar = @"http://oss.iclass.com/iclassbaby/50_50/1362030558065timls.jpg";
    member.reciverName = @"baby";
    member.reciverId = [NSNumber numberWithInt:1422];
    member.otherInfo = @"Teacher_1422_baby";
    [group1.memberList addObject:member];
    [member release];
    
    member = [[Reciver alloc] init];
    member.avatar = @"http://baby.iclass.com/public/img/userAvatar/50/ic_user.png";
    member.reciverName = @"和总";
    member.reciverId = [NSNumber numberWithInt:1433];
    member.otherInfo = @"Teacher_1433_和总";
    [group1.memberList addObject:member];
    [member release];
    
    member = [[Reciver alloc] init];
    member.avatar = @"http://baby.iclass.com/public/img/userAvatar/50/ic_user.png";
    member.reciverName = @"张燕";
    member.reciverId = [NSNumber numberWithInt:1434];
    member.otherInfo = @"Teacher_1434_张燕";
    [group1.memberList addObject:member];
    [member release];
    
    member = [[Reciver alloc] init];
    member.avatar = @"http://baby.iclass.com/public/img/userAvatar/50/ic_user.png";
    member.reciverName = @"成哲";
    member.reciverId = [NSNumber numberWithInt:1423];
    member.otherInfo = @"Teacher_1423_成哲";
    [group2.memberList addObject:member];
    [member release];
    
    member = [[Reciver alloc] init];
    member.avatar = @"http://baby.iclass.com/public/img/userAvatar/50/ic_user.png";
    member.reciverName = @"吴哥细";
    member.reciverId = [NSNumber numberWithInt:1417];
    member.otherInfo = @"Teacher_1417_吴哥细";
    [group2.memberList addObject:member];
    [member release];
    
    member = [[Reciver alloc] init];
    member.avatar = @"http://baby.iclass.com/public/img/userAvatar/50/ic_user.png";
    member.reciverName = @"徐玉珠";
    member.reciverId = [NSNumber numberWithInt:1415];
    member.otherInfo = @"Teacher_1415_徐玉珠";
    [group2.memberList addObject:member];
    [member release];
    // new add member
    member = [[Reciver alloc] init];
    member.avatar = @"http://www.iclass.com/public/img/defaultAvatar/fir_ava1.png";
    member.reciverName = @"测试者";
    member.reciverId = [NSNumber numberWithInt:2011];
    member.otherInfo = @"Teacher_2011_测试者";
    [group2.memberList addObject:member];
    [member release];
    
    member = [[Reciver alloc] init];
    member.avatar = @"http://www.iclass.com/public/img/defaultAvatar/fir_ava2.png";
    member.reciverName = @"被测试者";
    member.reciverId = [NSNumber numberWithInt:2012];
    member.otherInfo = @"Parent_2012_被测试者";
    [group2.memberList addObject:member];
    [member release];
    
    member = [[Reciver alloc] init];
    member.avatar = @"http://www.iclass.com/public/img/defaultAvatar/fir_ava3.png";
    member.reciverName = @"名字比较长的被测试者";
    member.reciverId = [NSNumber numberWithInt:2013];
    member.otherInfo = @"Parent_2013_名字比较长的被测试者";
    [group2.memberList addObject:member];
    [member release];
    
    member = [[Reciver alloc] init];
    member.avatar = @"http://www.iclass.com/public/img/defaultAvatar/fir_ava4.png";
    member.reciverName = @"短名字";
    member.reciverId = [NSNumber numberWithInt:2014];
    member.otherInfo = @"Teacher_2014_短名字";
    [group2.memberList addObject:member];
    [member release];
    
    member = [[Reciver alloc] init];
    member.avatar = @"http://www.iclass.com/public/img/defaultAvatar/fir_ava5.png";
    member.reciverName = @"1";
    member.reciverId = [NSNumber numberWithInt:2015];
    member.otherInfo = @"Teacher_2015_1";
    [group2.memberList addObject:member];
    [member release];
    
    member = [[Reciver alloc] init];
    member.avatar = @"http://www.iclass.com/public/img/defaultAvatar/fir_ava6.png";
    member.reciverName = @"马岩";
    member.reciverId = [NSNumber numberWithInt:2016];
    member.otherInfo = @"Parent_2016_马岩";
    [group2.memberList addObject:member];
    [member release];
    
    
    NSArray* result = [NSArray arrayWithObjects:group1,group2, nil];
    [group1 release];
    [group2 release];
    return result;
}
@end