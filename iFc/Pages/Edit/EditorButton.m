//
//  EditorButton.m
//  iFc
//
//  Created by xiang-chen on 14-7-17.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "EditorButton.h"
#import "FSConfig.h"

@implementation EditorButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fsFontWithSize:14.f];
        self.layer.cornerRadius = 22.f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:.2f alpha:.5f];
        self.layer.borderColor = [UIColor colorWithWhite:.8f alpha:.7f].CGColor;
        self.layer.borderWidth = 1.f;
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
