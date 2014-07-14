//
//  NSString+size.h
//  ymw
//
//  Created by an on 14-4-14.
//  Copyright (c) 2014年 yesmywine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (size)
-(CGSize)newSizeWithFont:(UIFont *)font;
-(CGSize)newSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
@end
