//
//  FSMenuViewController.m
//  gsc
//
//  Created by xiang-chen on 14-7-3.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "FSMenuViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "IAPContorl.h"

@interface FSMenuViewController ()<UIAlertViewDelegate>{

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


    self.cachedData  = [NSString stringWithFormat:@"Clear Cached (%.1fMB)",[FSConfig getFilePath]];
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
        
        self.cachedData  = [NSString stringWithFormat:@"Clear Cached (%.1fMB)",[FSConfig getFilePath]];
    }
    [self resetMenuArray];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithWhite:60.f/255.f alpha:1.f];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resetMenuArray{
    
    self.menuArray = @[
                       @[@"Home"],
                       @[
                           @"Rate",
                           @"Tell Friends",
                           @"Upgrade",
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
                               [hud setLabelText: NSLocalizedString(@"Error", nil)];
                               [hud hide:YES afterDelay:.5f];
                           }
                       }

                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];}
                   );

}

-(void)clearCacheSuccess
{
    self.cachedData  = @"Clear Cached (0.0MB)";
    [hud setLabelText: NSLocalizedString(@"Done", nil)];
    [hud hide:YES afterDelay:.5f];
    [self resetMenuArray];
    [self.tableView reloadData];
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
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
                // Load resources for iOS 6.1 or earlier
                navigationController.navigationBar.tintColor = [UIColor navBgColor];
            } else {
                // Load resources for iOS 7 or later
                navigationController.navigationBar.barTintColor = [UIColor navBgColor];
            }
            [self.mm_drawerController setCenterViewController:navigationController withFullCloseAnimation:YES completion:^(BOOL b) {
                
            }];
        }
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
                
                }
                    
                    break;
                case 1:{
                    
                    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                                       defaultContent:@"默认分享内容，没内容时显示"
                                                                image:nil
                                                                title:@"ShareSDK"
                                                                  url:@"http://www.sharesdk.cn"
                                                          description:@"这是一条测试信息"
                                                            mediaType:SSPublishContentMediaTypeNews];
                    
                    [ShareSDK showShareActionSheet:nil
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
//                    [UMSocialSnsService presentSnsController:self
//                                                         appKey:@"53ce1fc656240bfcee0271d3"
//                                                      shareText:@"lalalal"
//                                                     shareImage:nil
//                                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQQ,UMShareToFacebook,UMShareToTwitter,UMShareToInstagram,nil]
//                                                       delegate:self];
                }
                    
                    break;
                case 2:{
                
                    [IAPContorl showAlertByID:Product_NOiAd];
                }
                    
                    break;
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
        default:
            break;
    }
    if (indexPath.section == 1) {

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
