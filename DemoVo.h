//
//  DemoVo.h
//  superTabNavigator
//
//  Created by marco on 13-1-29.
//  Copyright (c) 2013年 marco. All rights reserved.
//

@interface DemoVo : NSObject

@property(nonatomic, retain)NSString* img;
@property(nonatomic, retain)NSString* title;
+(NSMutableArray*)createTestDatas;
+(DemoVo*)create:(NSString*)bgImg title:(NSString*)str;
@end
