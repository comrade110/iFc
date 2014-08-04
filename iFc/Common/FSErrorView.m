//
//  FSErrorView.m
//  iFc
//
//  Created by xiang-chen on 14-8-4.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "FSErrorView.h"
#import "FSConfig.h"

@implementation FSErrorView

- (id)initWithFrame:(CGRect)frame withAciontBlock:(RetryBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self removeFromSuperview];
        self.backgroundColor=[UIColor mainBgColor];
        UIButton *resetRequestButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [resetRequestButton handleControlWithBlock:^{
            [self removeFromSuperview];
            block();
        }];
        [self addSubview:resetRequestButton];
        
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noNetwork.png"]];
        imageView.center=CGPointMake(self.width/2, kXHISIPAD?230:135);
        [self addSubview:imageView];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, imageView.top+60, self.width-60*2, 60)];
        titleLabel.font=[UIFont systemFontOfSize:20];
        titleLabel.textColor=[UIColor colorWithWhite:180./255. alpha:1.f];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.numberOfLines=0;
        titleLabel.text=NSLocalizedString(@"Connection failure\nTap to Retry", nil);
        [self addSubview:titleLabel];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
