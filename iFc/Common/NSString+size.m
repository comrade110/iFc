//
//  NSString+size.m
//  ymw
//
//  Created by an on 14-4-14.
//  Copyright (c) 2014年 yesmywine. All rights reserved.
//

#import "NSString+size.h"

@implementation NSString (size)
-(CGSize)newSizeWithFont:(UIFont *)font
{
    return [self newSizeWithFont:font constrainedToSize:CGSizeMake(320, 999)];
}
-(CGSize)newSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    return [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:attributes
                              context:nil].size;
}
@end
