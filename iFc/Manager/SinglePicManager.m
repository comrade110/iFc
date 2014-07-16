//
//  SinglePicManager.m
//  iFc
//
//  Created by xiang-chen on 14-7-16.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "SinglePicManager.h"

@implementation SinglePicManager

+(SinglePicManager*)manager{
    static SinglePicManager* _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[SinglePicManager alloc] init];
    });
    return _manager;
}


@end
