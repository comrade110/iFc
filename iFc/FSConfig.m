//
//  FSConfig.m
//  iFc
//
//  Created by xiang-chen on 14-7-14.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "FSConfig.h"

@implementation FSConfig

+(NSString *) getCurrentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

+(float)getFilePath{
    //文件管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //缓存路径
    
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    
    NSString *cacheDir = [cachePaths objectAtIndex:0];
    NSArray *cacheFileList;
    NSEnumerator *cacheEnumerator;
    NSString *cacheFilePath;
    double cacheFolderSize = 0;
    cacheFileList = [fileManager subpathsOfDirectoryAtPath:cacheDir error:nil];
    cacheEnumerator = [cacheFileList objectEnumerator];
    while (cacheFilePath = [cacheEnumerator nextObject]) {
        NSDictionary *cacheFileAttributes = [fileManager attributesOfItemAtPath:[cacheDir stringByAppendingPathComponent:cacheFilePath] error:nil];
        cacheFolderSize += [cacheFileAttributes fileSize];
    }
    //单位MB
    NSLog(@"cacheFolderSize:%f",cacheFolderSize/1024/1024);
    return cacheFolderSize/1024/1024;
}

@end


@implementation UIColor (customSystemColor)

+(UIColor *)navBgColor
{
    return [UIColor colorWithRed:91./255. green:154./255. blue:167./255. alpha:1];
}

+(UIColor *)mainBgColor
{
    return [UIColor colorWithRed:208./255. green:217./255. blue:226./255. alpha:1];
}

+(UIColor *)mainCellColor
{
    return [UIColor colorWithRed:244./255. green:245./255. blue:249./255. alpha:1];
}

@end


@implementation UIFont (customSystemFont)

+(UIFont*)fsFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"Avenir-LightOblique" size:size];
}

@end;


void alert(NSString* msg){
	UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
	[alert show];
}