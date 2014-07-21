//
//  FSConfig.h
//  iFc
//
//  Created by xiang-chen on 14-7-14.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define FSWINDOW [[[UIApplication sharedApplication] delegate] window]

@interface FSConfig : NSObject


+(NSString *) getCurrentLanguage;

//TODO: 获得缓存文件大小
+(float)getFilePath;

@end


@interface UIColor (customSystemColor)
+(UIColor*)mainBgColor;
+(UIColor*)mainCellColor;
@end

@interface UIFont (customSystemFont)
+(UIFont*)fsFontWithSize:(CGFloat)size;
@end


extern void alert(NSString* msg);