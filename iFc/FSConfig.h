//
//  FSConfig.h
//  iFc
//
//  Created by xiang-chen on 14-7-14.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define FSWINDOW [[[UIApplication sharedApplication] delegate] window]

@interface FSConfig : NSObject


+(NSString *) getCurrentLanguage;

@end


@interface UIColor (customSystemColor)
+(UIColor*)mainBgColor;
+(UIColor*)mainCellColor;
@end

@interface UIFont (customSystemFont)
+(UIFont*)fsFontWithSize:(CGFloat)size;
@end