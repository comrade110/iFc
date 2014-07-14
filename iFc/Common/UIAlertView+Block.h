//
//  UIAlertView+Block.h
//  CMBH_Client_V2
//
//  Created by ma huajian on 13-3-13.
//  Copyright (c) 2013年 ma huajian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Block)<UIAlertViewDelegate>
/*
 *  handleWithBlock:
 *  使用block来处理alertview事件
 *  入参: block 使用block来处理alertview事件 例:^(int butIndex){CFShow(@"block");
 */
- (void)handleWithBlock:(void(^)(int))block;
/*
 *  changeBackground
 *  修改alert的外观,必须在show之后使用
 */
//-(void)changeBackground;
@end
