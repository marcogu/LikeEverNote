//
//  DemoVo.m
//  superTabNavigator
//
//  Created by marco on 13-1-29.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "DemoVo.h"

@implementation DemoVo

+(NSMutableArray*)createTestData
{
    DemoVo* demos[6];
    demos[0] = [[[DemoVo alloc] init] autorelease];
    demos[0].img  = @"premium-header-mid-skinny.png";
    demos[0].title = @"Go Premium";

    demos[1] = [[[DemoVo alloc] init] autorelease];
    demos[1].img  = @"bar-mid.png";
    demos[1].title = @"Places";
    
    demos[2] = [[[DemoVo alloc] init] autorelease];
    demos[2].img  = @"bar-mid.png";
    demos[2].title = @"Tags";
    
    demos[3] = [[[DemoVo alloc] init] autorelease];
    demos[3].img  = @"bar-mid.png";
    demos[3].title = @"Notebooks";
    
    demos[4] = [[[DemoVo alloc] init] autorelease];
    demos[4].img  = @"bar-mid.png";
    demos[4].title = @"All Notes";
    
    demos[5] = [[[DemoVo alloc] init] autorelease];
    demos[5].img  = @"bar-mid.png";
    demos[5].title = @"temp";
    
    
    NSArray* ary = [NSArray arrayWithObjects:demos count:2];
    return [ary mutableCopy];
}


@end
