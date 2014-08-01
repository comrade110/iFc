//
//  InstagramCollectionViewController.m
//  InstagramThumbnail
//
//  Created by 曾 宪华 on 14-2-23.
//  Copyright (c) 2014年 HUAJIE. All rights reserved.
//

#import "InstagramCollectionViewController.h"
#import "UICollectionViewController+ADFlipTransition.h"
#import "FSEditorViewController.h"
#import <Parse/Parse.h>
#import <StoreKit/StoreKit.h>
#import "GADBannerView.h"
#import "UIView+Frame.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

static NSString * const kXHInstagramFooter = @"InstagramFooter";

@interface InstagramCollectionViewController ()<GADBannerViewDelegate,UIAlertViewDelegate,SKStoreProductViewControllerDelegate>{

    PFImageView *imageView;
    GADBannerView *bannerView_;
    UIView *bottomADView;
    NSDate *startDate;
    NSDate *endData;
}

@property(nonatomic,assign) NSUInteger curPage;
@property(nonatomic,strong) GADRequest *request;

@end

@implementation InstagramCollectionViewController

#pragma mark - Propertys

- (NSMutableArray *)mediaArray {
    if (!_mediaArray) {
        _mediaArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _mediaArray;
}

- (XHInstagramStoreManager *)instagramStoreManager {
    if (!_instagramStoreManager) {
        _instagramStoreManager = [[XHInstagramStoreManager alloc] initWithObjectId:_objectId];
    }
    return _instagramStoreManager;
}

#pragma mark - Life cycle

- (void)_baseSetup {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicator startAnimating];
    self.downloading = YES;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    if ((self = [super initWithCollectionViewLayout:layout])) {
        [self _baseSetup];
    }
    return self;
}

+ (instancetype)sharedInstagramCollectionViewControllerWithObjectId:(NSString *)objectId {
    return nil;
}

- (id)init {
    self = [super init];
    if (self) {
        [self _baseSetup];
        imageView = [[PFImageView alloc] init];
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self downloadDataSource];
    [self rateControl];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([UIApplication sharedApplication].statusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)_setupCollectionView {
    [self.collectionView setBackgroundColor:[UIColor mainBgColor]];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kXHInstagramFooter];
    [self.collectionView registerClass:[InstagramCell class] forCellWithReuseIdentifier:kXHInstagramCell];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Instagram";
    self.curPage = 0;
    [self.view setBackgroundColor:[UIColor mainBgColor]];
    [self _setupCollectionView];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:@"Detail List"
           value:@"Detail List"];
    
    // Previous V3 SDK versions
    // [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    // New SDK versions
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    //AD
//    // 在屏幕顶部创建标准尺寸的视图。
//    // 在GADAdSize.h中对可用的AdSize常量进行说明。
//    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
//    
//    // 指定广告单元ID。
//    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
//    bannerView_.delegate = self;
//    // 告知运行时文件，在将用户转至广告的展示位置之后恢复哪个UIViewController
//    // 并将其添加至视图层级结构。
//    bannerView_.rootViewController = self;
//    [self.view addSubview:bannerView_];
//    
//    [self.view bringSubviewToFront:bannerView_];
//    
//    // 启动一般性请求并在其中加载广告。
//    self.request = [GADRequest request];
//    [bannerView_ loadRequest:_request];
//    // 请求测试广告。填入模拟器
//    // 以及接收测试广告的任何设备的标识符。
//    _request.testDevices = [NSArray arrayWithObjects:
//                           @"2DEA15FF-9698-505D-931C-68E2B9A3CEFF",
//                           @"f2751b6ab2923ef5171dfb289dc50c9678520ecd",
//                           nil];
//
//    bottomADView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height -bannerView_.height, bannerView_.height, bannerView_.height)];
//    [bottomADView addSubview:bannerView_];
//    bottomADView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    [self.view addSubview:bottomADView];
//    [self.view bringSubviewToFront:bottomADView];
//    
}

// 收到广告调整collectionView frame
- (void)adViewDidReceiveAd:(GADBannerView *)view{
    NSLog(@"======%@=======",view.adNetworkClassName);
    if (self.collectionView.height == self.view.height) {
        self.collectionView.frame = CGRectMake(0, 0, self.collectionView.width, self.collectionView.height-view.height);
    }


}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error{

    [bannerView_ loadRequest:_request];
}


#pragma mark - rate contorl

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
                 startDate = [NSDate date];
             }
              ];
         }
     }];
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        endData = [NSDate date];
        // 判断进入APP store时间 少于8秒不算评论
        if ([endData timeIntervalSinceDate:startDate]<8.f) {
            startDate = nil;
            endData = nil;
        }else{
            startDate = nil;
            endData = nil;
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"saveCount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}


-(void)rateControl{
    // 每启动N次显示评分
    NSInteger saveCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"saveCount"] intValue];
    if (saveCount < SAVEMAXCOUNT && saveCount != 0) {
    }else if(saveCount == 0){
        // 用户选择了不再提示打分
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enjoying iFace+?", nil)
                                                            message:NSLocalizedString(@"If so, say it with stars on the App Store",nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Remind me later", nil)
                                                  otherButtonTitles:NSLocalizedString(@"OK,I give stars", nil),NSLocalizedString(@"Don't ask again", nil), nil
                                  ];
        [alertView show];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"saveCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            // 跳转到APP STORE
            [self evaluate];
            break;
        case 2:
            // 不再提示
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"saveCount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
            
        default:
            break;
    }
    
}


#pragma mark - DataSource manager 

- (void)downloadDataSource {
    self.downloading = YES;
    if ([self.mediaArray count] == 0) {
        [self.instagramStoreManager mediaWithPage:self.curPage localDownloadDataSourceCompled:^(NSArray *mediaArray, NSError *error) {
            if (error || mediaArray.count == 0) {
                showAlert(@"Instagram", @"No results found", @"OK");
            }else{
                [self.mediaArray addObjectsFromArray:mediaArray];
                [self.collectionView reloadData];
            }
            self.downloading = NO;
            self.curPage ++;
            
            [self.activityIndicator stopAnimating];
        }];
    }else{
        [self.instagramStoreManager mediaWithPage:self.curPage localDownloadDataSourceCompled:^(NSArray *mediaArray, NSError *error) {
            self.curPage ++;
            NSUInteger a = [self.mediaArray count];
            [self.mediaArray addObjectsFromArray:mediaArray];
            
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            [mediaArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSUInteger b = a+idx;
                NSIndexPath *path = [NSIndexPath indexPathForItem:b inSection:0];
                [arr addObject:path];
            }];
            
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:arr];
            } completion:nil];
            
            self.downloading = NO;
            
            if (mediaArray.count == 0) {
                self.activityIndicator.hidden = YES;
                self.hideFooter = YES;
                [self.collectionView reloadData];
            }
            
            [self.activityIndicator stopAnimating];
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.mediaArray count];
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InstagramCell *instagramCell =  [collectionView dequeueReusableCellWithReuseIdentifier:kXHInstagramCell forIndexPath:indexPath];
    
    if ([self.mediaArray count] > 0) {
         PFObject* entity = [self.mediaArray objectAtIndex:indexPath.row];
        [instagramCell setEntity:entity andIndexPath:indexPath];
        
    }
    
    if (indexPath.row == [self.mediaArray count] - 1 && !self.downloading) {
        [self downloadDataSource];
    }
    
    return instagramCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.hideFooter) {
        return CGSizeZero;
    }
    return CGSizeMake(CGRectGetWidth(self.view.frame), 40);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind != UICollectionElementKindSectionFooter || self.hideFooter) {
        return nil;
    }
    
    UICollectionReusableView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kXHInstagramFooter forIndexPath:indexPath];
    
    CGPoint center = self.activityIndicator.center;
    center.x = foot.center.x;
    center.y = 20;
    self.activityIndicator.center = center;
    
    [foot addSubview:self.activityIndicator];
    
    return foot;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    InstagramCell *cell = (InstagramCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    FSEditorViewController *editorVC = [[FSEditorViewController alloc] init];
    editorVC.bgImg = cell.imageView.image;
    [SinglePicManager manager].entity = cell.entity;
    [self flipToViewController:editorVC fromItemAtIndexPath:indexPath withSourceSnapshotImage:cell.imageView.image andDestinationSnapshot:cell.imageView.image withCompletion:^{
         [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
      }];
}


@end
