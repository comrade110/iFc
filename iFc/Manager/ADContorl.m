//
//  ADContorl.m
//  iFc
//
//  Created by xiang-chen on 14-8-6.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "ADContorl.h"

@implementation ADContorl

+(ADContorl*)manager{
    static ADContorl* _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ADContorl alloc] init];
        
    });
    return _manager;
}

//-(void)createAdView{
//    BOOL inPortrait = UIInterfaceOrientationIsPortrait(self.interfaceOrientation);
//    GADAdSize adMobSize;
//    if (kUseAdMobSmartSize) {
//        if (!inPortrait)
//            adMobSize = kGADAdSizeSmartBannerLandscape;
//        else
//            adMobSize = kGADAdSizeSmartBannerPortrait;
//        _adMobView = [[GADBannerView alloc] initWithAdSize:adMobSize];
//    }else{
//        // Legacy AdMob ad sizes don't fill the full width of the device screen apart from iPhone when in portrait view
//        // We need to offset the x position so the ad appears centered - Calculation: (View width - Ad width) / 2
//        // Problem is that getting the width of the bounds doesn't take into account the current orientation
//        // As a workaround, if we're in landscape, we'll simply get the height instead
//        CGRect screen = [[UIScreen mainScreen] bounds];
//        CGFloat screenWidth = inPortrait ? CGRectGetWidth(screen) : CGRectGetHeight(screen);
//        adMobSize = kXHISIPAD ? kGADAdSizeLeaderboard : kGADAdSizeBanner;
//        CGSize cgAdMobSize = CGSizeFromGADAdSize(adMobSize);
//        CGFloat adMobXOffset = (screenWidth-cgAdMobSize.width)/2;
//        _adMobView = [[GADBannerView alloc] initWithFrame:CGRectMake(adMobXOffset, self.view.frame.size.height - cgAdMobSize.height, cgAdMobSize.width, cgAdMobSize.height)];
//    }
//    
//    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
//    _adMobView.adUnitID = kAdMobID;
//    // Set initial frame to be off screen
//    CGRect bannerFrame = _adMobView.frame;
//    if([kAdPosition isEqualToString:@"bottom"])
//        bannerFrame.origin.y = [[UIScreen mainScreen] bounds].size.height;
//    else if([kAdPosition isEqualToString:@"top"])
//        bannerFrame.origin.y = 0 - _adMobView.frame.size.height;
//    _adMobView.frame = bannerFrame;
//    
//    // Let the runtime know which UIViewController to restore after taking
//    // the user wherever the ad goes and add it to the view hierarchy.
//    _adMobView.rootViewController = self;
//    _adMobView.delegate = self;
//    [_containerView addSubview:_adMobView];
//    
//    // Request an ad
//    GADRequest *adMobRequest = [GADRequest request];
//    // Uncomment the following line if you wish to receive test ads (simulator only)
//    adMobRequest.testDevices = [NSArray arrayWithObjects:
//                                @"2DEA15FF-9698-505D-931C-68E2B9A3CEFF",
//                                @"f2751b6ab2923ef5171dfb289dc50c9678520ecd",
//                                nil];
//    
//    [_adMobView loadRequest:adMobRequest];
//}


@end
