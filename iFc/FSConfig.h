//
//  FSConfig.h
//  iFc
//
//  Created by xiang-chen on 14-7-14.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "UIView+Frame.h"
#import "UIButton+Block.h"
#import "CJPAdController.h"
#import "FSErrorView.h"
#import "IAPContorl.h"

#define MY_BANNER_UNIT_ID @"ca-app-pub-4053211758441927/7334362495"
#define MY_INTERSTITIAL_UNIT_ID @"ca-app-pub-4053211758441927/5166298497"
#define MY_GAI @"UA-53388064-2"
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define FSWINDOW [[[UIApplication sharedApplication] delegate] window]



//业务
#define DELEGATEADCOUNT 3
#define EDITVCADCOUNT 3
#define LaunchMAXCount 5
#define SAVEMAXCOUNT 5

#define isPurchased [[NSUserDefaults standardUserDefaults] boolForKey:CJPAdsPurchasedKey]


@interface FSConfig : NSObject


+(NSString *) getCurrentLanguage;

//TODO: 获得缓存文件大小
+(float)getFilePath;

@end


@interface UIColor (customSystemColor)
+(UIColor *)navBgColor;
+(UIColor*)mainBgColor;
+(UIColor*)mainCellColor;
@end

@interface UIFont (customSystemFont)
+(UIFont*)fsFontWithSize:(CGFloat)size;
@end


extern void alert(NSString* msg);