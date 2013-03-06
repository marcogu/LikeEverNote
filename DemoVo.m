//
//  DemoVo.m
//  superTabNavigator
//
//  Created by marco on 13-1-29.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "DemoVo.h"

@implementation DemoVo

+(DemoVo*)create:(NSString*)bgImg title:(NSString*)str
{
    DemoVo* value = [[[DemoVo alloc] init] autorelease];
    value.img = bgImg;
    value.title = str;
    return value;
}


@end
