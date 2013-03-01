//
//  CardItemRegister.h
//  superTabNavigator
//
//  Created by marco on 13-3-1.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardItemRegister : NSObject
@property (nonatomic, assign) Class targetClass;
@property (nonatomic, assign) id    targetObject;
@property (nonatomic) int  policy;
@property (nonatomic, retain) NSObject* params;
@end
