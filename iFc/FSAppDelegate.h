//
//  FSAppDelegate.h
//  iFc
//
//  Created by xiang-chen on 14-7-14.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADInterstitial.h"
#import "FSConfig.h"


@interface FSAppDelegate : UIResponder <UIApplicationDelegate,GADInterstitialDelegate>{

    GADInterstitial *splashInterstitial_;
    CJPAdController *_adController;
}
@property (strong, nonatomic) GADRequest *request;
@property (strong, nonatomic) UIWindow *window;

@end
