//
//  FSErrorView.h
//  iFc
//
//  Created by xiang-chen on 14-8-4.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RetryBlock)(void);

@interface FSErrorView : UIView

- (id)initWithFrame:(CGRect)frame withAciontBlock:(RetryBlock)block;

@end
