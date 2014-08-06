//
//  ADContorl.h
//  iFc
//
//  Created by xiang-chen on 14-8-6.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADBannerView.h"

//// Your AdMob publisher ID
//static NSString * const kAdMobID = @"ca-app-pub-4053211758441927/7334362495";
//
//// Use AdMob's "Smart" size banners (will fill full width of device)
//// If set to NO, 320x50 ads will be used for iPhone/iPod and 728x90 for iPad
//static BOOL const kUseAdMobSmartSize = YES;
//
//// Where to position the ad on screen ("top" or "bottom")
//static NSString * const kAdPosition = @"bottom";
//
//// Seconds to wait before displaying ad after the view loads (0.0 = instant)
//static float const kWaitTime = 3.0;
//
//// Name of UserDefaults key for if ads have been purchased (you can ignore this if you don't have an IAP to remove ads)
//static NSString * const kAdsPurchasedKey = @"adRemovalPurchased";
//
//// Are you testing? Setting to YES will NSLog various events
//static BOOL const kAdTesting = YES;

@interface ADContorl : NSObject

@property (nonatomic, strong) GADBannerView     *adMobView;

+(ADContorl*)manager;
- (void)removeAllAdsForever;

@end
