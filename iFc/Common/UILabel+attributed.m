//
//  UILabel+attributed.m
//  ymw
//
//  Created by an on 14-4-11.
//  Copyright (c) 2014年 yesmywine. All rights reserved.
//

#import "UILabel+attributed.h"

@implementation UILabel (attributed)
-(void)defaultAttributedText
{
    if(!self.text)self.text=@"";
    if(!self.textColor)self.textColor=[UIColor blackColor];
    if(!self.font)self.font=[UIFont systemFontOfSize:15];
    self.attributedText=[[NSAttributedString alloc]initWithString:self.text attributes:@{NSForegroundColorAttributeName:self.textColor,NSFontAttributeName:self.font,NSTextEffectAttributeName:NSTextEffectLetterpressStyle}];
}
@end
