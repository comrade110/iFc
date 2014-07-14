//
//  NSObject+Objects.h
//  MyDemo4
//
//  Created by ma huajian on 14-1-2.
//  Copyright (c) 2014年 ma huajian. All rights reserved.
//

#import <Foundation/Foundation.h>

//为了让performSelector:后面带入的参数可识别,很有必要将bool封装一层,用于在后面解析函数时候的识别
@interface BoolClass:NSObject
@property (nonatomic,assign)BOOL b_;
+(BoolClass *)getBoolClass:(BOOL)b2_;
@end
#define BOOLCLASS(b) [BoolClass getBoolClass:b]


@interface NSObject (Objects)
//远端调用的时候可扩展,不受两个参数的限制
- (id)performSelector:(SEL)aSelector withObjects:(id)object1,... NS_REQUIRES_NIL_TERMINATION;
@end
