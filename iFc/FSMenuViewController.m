//
//  FSMenuViewController.m
//  gsc
//
//  Created by xiang-chen on 14-7-3.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "FSMenuViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <StoreKit/StoreKit.h>
#import "IAPContorl.h"

@interface FSMenuViewController ()<UIAlertViewDelegate,SKStoreProductViewControllerDelegate>{

    MBProgressHUD *hud;

}

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *menuArray;
@property(nonatomic,strong) NSArray *menuImgArray;
@property(nonatomic,copy) NSString *cachedData;

@end

@implementation FSMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{


     self.cachedData  = [NSString stringWithFormat:@"%@ (%.1fMB)",NSLocalizedString(@"Clear Cached", nil),[FSConfig getFilePath]];
    if (_tableView) {
        [self resetMenuArray];
        [_tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithWhite:1.f/255.f alpha:1.f];
    
    if (!self.cachedData) {
        self.cachedData  = [NSString stringWithFormat:@"%@ (%.1fMB)",NSLocalizedString(@"Clear Cached", nil),[FSConfig getFilePath]];
    }
    [self resetMenuArray];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithWhite:60.f/255.f alpha:1.f];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView =nil;

    [self.view addSubview:_tableView];
}

- (void)evaluate{
    
    //初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId唯一的
     @{SKStoreProductParameterITunesItemIdentifier : @"904153091"} completionBlock:^(BOOL result, NSError *error) {
         //block回调
         if(error){
             NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             //模态弹出appstore
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
                 
             }
              ];
         }
     }];
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)resetMenuArray{
    
    self.menuArray = @[
                       @[NSLocalizedString(@"Home", nil)],
                       @[
                           NSLocalizedString(@"Rate", nil),
                           NSLocalizedString(@"Tell Friends", nil),
                           NSLocalizedString(@"Upgrade", nil),
                           _cachedData,
                           ],
                       @[@"Copyright"],
                       ];
    self.menuImgArray = @[
                       @[@"home_icon"],
                       @[
                           @"rate_icon",
                           @"tellFriends_icon",
                           @"upgrade_icon",
                           @"clearCached_icon",
                           ],
                       @[@"copyright_icon"],
                       ];
    [_tableView reloadData];
}

-(void)clearCache{
    

    hud = [MBProgressHUD showHUDAddedTo:FSWINDOW animated:YES];
    hud.labelText = NSLocalizedString(@"Waiting", nil);
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%ld",[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                           if (error) {
                           }
                       }

                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];}
                   );

}

-(void)clearCacheSuccess
{
    self.cachedData  = [NSString stringWithFormat:@"%@ (0.0MB)",NSLocalizedString(@"Clear Cached", nil)];
    [hud setLabelText: NSLocalizedString(@"Done", nil)];
    [hud hide:YES afterDelay:.5f];
    [self resetMenuArray];
    [self.tableView reloadData];
}


-(void)sharePressed{
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionAny];
    
    NSString *str = [NSString stringWithFormat:@"%@ http://goo.gl/L9jNZw",NSLocalizedString(@"iFace+ make your life more colorful", nil)];
    id<ISSContent> publishContent = [ShareSDK content:str
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:nil
                                                title:@"iFace+"
                                                  url:@"http://goo.gl/L9jNZw"
                                          description:@"iFace+"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:kXHISIPAD?container:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error  errorDescription]);
                                }
                            }];


}

//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    NSLog(@"response:%@",response);
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//        //得到分享到的微博平台名
//        alert([NSString stringWithFormat:@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]]);
//    }else{
//        alert(@"Send failed");
//    }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [self.menuArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuArray[section] count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 80.f;
    }else{
        return 15.f;
    }

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor colorWithWhite:55.f/255.f alpha:1.f];
    UIView *selectdView = [[UIView alloc] initWithFrame:cell.frame];
    selectdView.backgroundColor = [UIColor colorWithWhite:50.f/255.f alpha:1.f];
    cell.selectedBackgroundView = selectdView;
    cell.textLabel.text = self.menuArray[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:240.f/255.f alpha:1.f];
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.imageView.frame = CGRectMake(cell.imageView.left, cell.imageView.top, 15, 15);
    cell.imageView.image = [UIImage imageNamed:self.menuImgArray[indexPath.section][indexPath.row]];

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:{
            UIViewController * centerViewController =  [NSClassFromString(@"FSViewController") new];
            ;
            UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
            
            navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
            navigationController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                // Load resources for iOS 6.1 or earlier
                navigationController.navigationBar.tintColor = [UIColor navBgColor];
            } else {
                // Load resources for iOS 7 or later
                navigationController.navigationBar.barTintColor = [UIColor navBgColor];
                navigationController.navigationBar.tintColor = [UIColor whiteColor];
            }
            if (kXHISIPAD) {
                [self.mm_drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:^(BOOL b) {
                    
                }];
            }else{
                [self.mm_drawerController setCenterViewController:navigationController withFullCloseAnimation:YES completion:^(BOOL b) {
                    
                }];
            }

        }
            break;
        case 1:{
            switch (indexPath.row) {
                // rate
                case 0:{
                
                    [self evaluate];
                }
                    
                    break;
                    // share
                case 1:
                    [self sharePressed];
                    break;
                case 2:{
                 // iap
                    [IAPContorl showAlertByID:Product_NOiAd];
                }
                    
                    break;
                 // clean cached
                case 3:{
                    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"FirstCleanCached"]){
                        
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstCleanCached"];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"All images you downloaded will be cleared", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
                        [alert show];
                        
                    }else{
                     [self clearCache];
                    }

                }
                    
                    break;
                case 4:
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    {
                        UIViewController * centerViewController =  [NSClassFromString(@"FSCopyrightViewController") new];
                        ;
                        UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
                        
                        navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
                        navigationController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
                        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                            // Load resources for iOS 6.1 or earlier
                            navigationController.navigationBar.tintColor = [UIColor navBgColor];
                        } else {
                            // Load resources for iOS 7 or later
                            navigationController.navigationBar.barTintColor = [UIColor navBgColor];
                            navigationController.navigationBar.tintColor = [UIColor whiteColor];
                        }
                        if (kXHISIPAD) {
                            [self.mm_drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:^(BOOL b) {
                            
                        }];
                        }else{
                            [self.mm_drawerController setCenterViewController:navigationController withFullCloseAnimation:YES completion:^(BOOL b) {
                                
                            }];
                        }
                    }
                    break;
                }
                    
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }


}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        [self clearCache];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstCleanCached"];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
