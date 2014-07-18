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

@end


@implementation UIColor (customSystemColor)

+(UIColor *)mainBgColor
{
    return [UIColor colorWithRed:231./255. green:235./255. blue:238./255. alpha:1];
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