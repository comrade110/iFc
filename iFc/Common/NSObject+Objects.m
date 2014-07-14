//
//  NSObject+Objects.m
//  MyDemo4
//
//  Created by ma huajian on 14-1-2.
//  Copyright (c) 2014年 ma huajian. All rights reserved.
//

#import "NSObject+Objects.h"
@implementation BoolClass
+(BoolClass *)getBoolClass:(BOOL)b2_
{
    BoolClass *bc=[BoolClass new];
    bc.b_=b2_;
    return bc;
}
@end
@implementation NSObject (Objects)
- (id)performSelector:(SEL)aSelector withObjects:(id)object,... NS_REQUIRES_NIL_TERMINATION
{
    va_list args;
    va_start(args, object);
    NSInteger index=2;//0 是本身,1 是SEL
    NSMethodSignature *sig=[self.class instanceMethodSignatureForSelector:aSelector];
    NSInvocation *invo=[NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:aSelector];
//    BOOL arguments=NO;
    for(id isId=object;isId!=nil;isId=va_arg(args, id),index++)
    {
        //        [allStr appendFormat:@"%@%ld -",object,index];
        //        if([isId isKindOfClass:NSNumber.class])
        //            NSLog(@"%d-%ld -",[isId intValue],index);
        //        else
//        NSLog(@"%@-%ld -",isId,index);
        if([isId isKindOfClass:BoolClass.class])
        {
            BOOL b_=((BoolClass *)isId).b_;
//            NSNumber *num=[NSNumber numberWithBool:b_];
            [invo setArgument:&b_ atIndex:index];
            continue;
        }
//        arguments=YES;
        [invo setArgument:&isId atIndex:index];
    }
    va_end(args);
//    if(arguments)
    [invo retainArguments];
    [invo invoke];
    //    NSLog(@"%@",allStr);
    //    [allStr release];
    
    //返回函数调用后的返回值
    const char *returnType=sig.methodReturnType;
    id returnValue;
    if(!strcasecmp(returnType, @encode(void)))//没有返回值
    {
        returnValue=nil;
    }else if(!strcasecmp(returnType, @encode(id))){//返回值为对象
        [invo getReturnValue:&returnValue];
    }else{//返回值为NSInteger Bool
        void *buffer=(void *)malloc([sig methodReturnLength]);
        [invo getReturnValue:buffer];
        if(!strcasecmp(returnType, @encode(BOOL)))
            returnValue=[NSNumber numberWithBool:*((BOOL *)buffer)];
        else    if(!strcasecmp(returnType, @encode(NSInteger)))
            returnValue=[NSNumber numberWithBool:*((NSInteger *)buffer)];
        else
            returnValue=[NSNumber numberWithBool:(BOOL)buffer];
    }
    return returnValue;
}
@end
