//
//  UIButton+Block.m
//  CMBH_Client_V2
//
//  Created by ma huajian on 13-3-1.
//  Copyright (c) 2013年 ma huajian. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>
@implementation UIButton (Block)
- (void)handleControlWithBlock:(ActionBlock)block
{
    objc_setAssociatedObject(self, &"myBlock", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self
             action:@selector(blockEvent:)
   forControlEvents:UIControlEventTouchUpInside];
//    NSArray *array=[self actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
//    for(int i=0;i<array.count;i++)
//    {
//        if([self allTargets].allObjects[i]!=self)
//        {
////            NSArray *arr=[self actionsForTarget:([self allTargets].allObjects[i])
////                                forControlEvent:UIControlEventTouchUpInside];
//            [self removeTarget:self
//                        action:(SEL)array[i]
//              forControlEvents:UIControlEventTouchUpInside];
//        }
//    }
}
-(void)blockEvent:(UIButton *)sender
{
    ActionBlock block=objc_getAssociatedObject(self, &"myBlock");
    if(block)
    {
        block();
    }
}
@end
