//
//  SinglePicManager.h
//  iFc
//
//  Created by xiang-chen on 14-7-16.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface SinglePicManager : NSObject

@property(nonatomic,strong) PFObject *entity;

+(SinglePicManager*)manager;

@end
