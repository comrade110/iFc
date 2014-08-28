//
//  FSAppDelegate.m
//  iFc
//
//  Created by xiang-chen on 14-7-14.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "FSAppDelegate.h"
#import "FSMenuViewController.h"
#import <Parse/Parse.h>
#import "FSViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "MMExampleDrawerVisualStateManager.h"
#import <ShareSDK/ShareSDK.h>
#import "IAPContorl.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <RevMobAds/RevMobAds.h>
#import "GAI.h"
//#import "WeiboSDK.h"

@implementation FSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
     [ShareSDK registerApp:@"26b6131cd4e5"];
    
    
    if ([[FSConfig getCurrentLanguage] isEqualToString:@"zh-Hans"]||[[FSConfig getCurrentLanguage] isEqualToString:@"zh-Hant"]) {
    }else{
        
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //  内购配置
    [IAPContorl createProducts];
    
    //添加Facebook应用  注册网址 https://developers.facebook.com
    [ShareSDK connectFacebookWithAppKey:@"1533652706857414"
                              appSecret:@"004c5ff9b49fbda532dba0bcbd9adda8"];
    
    //添加Twitter应用  注册网址  https://dev.twitter.com
    [ShareSDK connectTwitterWithConsumerKey:@"hB9ln89h4gsHYFa7yOxvRt33Y"
                             consumerSecret:@"PftAyFognU49j7PLKXtD2UDou3MboQJvVn6YApJPfi8FNtY9Mt"
                                redirectUri:@"http://sharesdk.cn"];
//    [ShareSDK connectSinaWeiboWithAppKey:@"2270857739" appSecret:@"c409e0b39bab52b4fd6fad4f081c6856" redirectUri:@"http://sharesdk.cn"];
//    [ShareSDK  connectSinaWeiboWithAppKey:@"2270857739"
//                                appSecret:@"c409e0b39bab52b4fd6fad4f081c6856"
//                              redirectUri:@"http://www.sharesdk.cn"
//                              weiboSDKCls:[WeiboSDK class]];

    //添加QQ应用
    [ShareSDK connectQQWithQZoneAppKey:@"1101989570"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    [ShareSDK importQQClass:[QQApiInterface class]
            tencentOAuthCls:[TencentOAuth class]];
//    [ShareSDK connectFlickrWithApiKey:@"3de37b66f2669f3ab8fa2b3314aec276" apiSecret:@"1cc23838602ed479"];
    
    [ShareSDK connectMail];
    
    //revmob ad
    [RevMobAds startSessionWithAppID:@"53ed97374ee531d05984fb4e"];
    [RevMobAds session].userInterests = @[@"games", @"mobile", @"app", @"photo"];
    [RevMobAds session].userAgeRangeMax = 30;
    [RevMobAds session].userAgeRangeMin = 10;
    
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    [Parse setApplicationId:@"vc9WStKb2rrh0dgDhyRy9yTyk37pMHtLhaaoGJv0"
                  clientKey:@"azLZ7rV2QZSd8X3WoW6xt1mHLZxFoQGQbipAYYuN"];
    //
    // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
    // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
    // [PFFacebookUtils initializeFacebook];
    // ****************************************************************************
    
    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    // Override point for customization after application launch.
 
//    //parse统计
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
//   google统计
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-53388064-2"];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    // Enable IDFA collection.
    [tracker setAllowIDFACollection:YES];

//
//    if (application.applicationState != UIApplicationStateBackground) {
//        // Track an app open here if we launch with a push, unless
//        // "content_available" was used to trigger a background push (introduced
//        // in iOS 7). In that case, we skip tracking here to avoid double
//        // counting the app-open.
//        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
//        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
//        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
//            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
//        }
//    }
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    UIViewController * leftSideDrawerViewController = [[FSMenuViewController alloc] init];
    
    UIViewController * centerViewController = [[FSViewController alloc] init];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];

        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            // Load resources for iOS 6.1 or earlier
            navigationController.navigationBar.tintColor = [UIColor navBgColor];
        } else {
            // Load resources for iOS 7 or later
            navigationController.navigationBar.barTintColor = [UIColor navBgColor];
            navigationController.navigationBar.tintColor = [UIColor whiteColor];
        }
//    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:navigationController
                                             leftDrawerViewController:leftSideDrawerViewController
                                             rightDrawerViewController:nil];
    [drawerController setMaximumLeftDrawerWidth:kXHISIPAD?300:200];
    
    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [[MMExampleDrawerVisualStateManager sharedManager]
                 drawerVisualStateBlockForDrawerSide:MMDrawerSideLeft];
        if(block){
            block(drawerController, drawerSide, percentVisible);
            [MMDrawerVisualState swingingDoorVisualStateBlock];
        }
    }];
    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:4];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    

    [CJPAdController sharedInstance].adNetworks = @[@(CJPAdNetworkAdMob)];
    [CJPAdController sharedInstance].adPosition = CJPAdPositionBottom;
    [CJPAdController sharedInstance].initialDelay = 2.0;
    // AdMob specific
    [CJPAdController sharedInstance].adMobUnitID = MY_BANNER_UNIT_ID;
    [CJPAdController sharedInstance].useAdMobSmartSize = YES;
    [[CJPAdController sharedInstance] startWithViewController:drawerController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:[CJPAdController sharedInstance]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"saveCount"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"EditerVCADControl"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"第一次启动");
    }else{
        
    }
    
    
    return YES;
}


- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
