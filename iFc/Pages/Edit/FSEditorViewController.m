//
//  FSEditorViewController.m
//  iFc
//
//  Created by chx on 14/7/15.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "FSEditorViewController.h"
#import "EditorButton.h"
#import "UIView+Frame.h"
#import "UIImage+Utility.h"
#import "MBProgressHUD.h"
#import "GADInterstitial.h"

#define IMAGESIZE 2

static const NSTimeInterval kAnimationIntervalTransform = 0.2;

@interface FSEditorViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,GADInterstitialDelegate>{

    UIView *saveView;
    PFImageView *imageView;
    UIImageView *userImageView;
    UIView *usershadowImageView;
    UIImage *thumnailImage;
    UIImageView *tempView;
    
    SEL showProgress;
    EditorButton *closeBtn;
    EditorButton *editBtn;
    EditorButton *getPhotoBtn;
    EditorButton *saveBtn;
    UISlider *saturationSlider;
    UISlider *brightnessSlider;
    UISlider *contrastSlider;
    MBProgressHUD *hud;
    BOOL isBGDone;
    GADRequest *request;
    
     GADInterstitial *interstitial_;
}

//@property(nonatomic,strong) UIView *saveView;   //For save
//
//@property(nonatomic,strong) PFImageView *imageView;
//@property(nonatomic,strong) UIImageView *userImageView;
//@property(nonatomic,strong) UIView *usershadowImageView;
//@property(nonatomic,strong) UIImage *thumnailImage;
//@property(nonatomic,strong) UIImageView *tempView;
@property (retain, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (retain, nonatomic) UIRotationGestureRecognizer *rotationRecognizer;
@property (retain, nonatomic) UIPinchGestureRecognizer *pinchRecognizer;

@property (nonatomic, strong) UIPopoverController *popVC;


@property(nonatomic,assign) CGFloat minimumScale;
@property(nonatomic,assign) CGFloat maximumScale;
@property CGFloat lastRotation;
@property(nonatomic,assign) NSUInteger gestureCount;
@property(nonatomic,assign) CGPoint touchCenter;
@property(nonatomic,assign) CGPoint rotationCenter;
@property(nonatomic,assign) CGPoint scaleCenter;
@property(nonatomic,assign) CGFloat scale;




@end

@implementation FSEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidDisappear:(BOOL)animated{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化广告
    [self preLoadInterstitial];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageView = [[PFImageView alloc] initWithFrame:self.view.frame];
    saveView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:saveView];
    [self.view sendSubviewToBack:saveView];
    
    hud = [MBProgressHUD showHUDAddedTo:imageView animated:YES];
    hud.labelText = @"Loading";
    
    imageView.image = _bgImg;
    imageView.file = [[SinglePicManager manager] entity][@"imageData"];
    
    DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 40.0f, 40.0f)];
    progressView.center = imageView.center;
    progressView.progress=0.0f;
    progressView.hidden = YES;
    [imageView addSubview:progressView];
    
    WEAKSELF
//
//    
//
//    
//    //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
//    //设置时间为2
//    double delayInSeconds = 0.8;
//    //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
//    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    //推迟两纳秒执行
//    dispatch_queue_t concurrentQueue =dispatch_get_main_queue();
//    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
//        progressView.hidden = NO;
//    });
//
//    
    NSLog(@"sdasdasda:%@",imageView.file.url);
    
    [imageView.file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        [MBProgressHUD hideHUDForView:imageView animated:YES];
        if (!error) {
            imageView.image = [UIImage imageWithData:data];
        }else{
            alert(NSLocalizedString(@"Connection failed, please try again later.", nil));
            [weakSelf dismissFlipWithCompletion:NULL];
        }
//        [progressView removeFromSuperview];
    } progressBlock:^(int percentDone) {
        if (hud.mode == MBProgressHUDModeIndeterminate) {
            hud.mode = MBProgressHUDModeDeterminate;
        }

        hud.progress = (float)percentDone/100;
        if (hud.progress == 1) {
            isBGDone = YES;
        }
        
    }];
    [saveView addSubview:imageView];
    
    //用户导入的图片
    [self buildUserImageView];
    
    //  底部工具栏
    [self bulidToolsView];
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 20, 35, 35);
    [backBtn setImage:[UIImage imageNamed:@"edit_back"] forState:UIControlStateNormal];
    
    [backBtn handleControlWithBlock:^{
        [weakSelf dismissFlipWithCompletion:NULL];
        hud.delegate = nil;
        
        // 下面三句不加会莫名其妙的不能释放内存  有待研究
        imageView.image = nil;
        imageView.file = nil;
        [imageView removeFromSuperview];
        
        interstitial_.delegate = nil;
        interstitial_ = nil;
        weakSelf.panRecognizer.delegate = nil;
        weakSelf.rotationRecognizer.delegate = nil;
        weakSelf.pinchRecognizer.delegate = nil;


    }];
    [self.view addSubview:backBtn];
    
    // Do any additional setup after loading the view.
}


#pragma mark - interstitial contorl


-(void)preLoadInterstitial{
    
    //AD
    BOOL  adsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:kAdsPurchasedKey];
    if (!adsRemoved) {
        interstitial_ = [[GADInterstitial alloc] init];
        interstitial_.adUnitID = MY_INTERSTITIAL_UNIT_ID;
        interstitial_.delegate = self;
        
        request =[GADRequest request];
        
        
        [interstitial_ loadRequest:request];
        // 请求测试广告。填入模拟器
        // 以及接收测试广告的任何设备的标识符。
        request.testDevices = [NSArray arrayWithObjects:
                               @"2DEA15FF-9698-505D-931C-68E2B9A3CEFF",
                               @"f2751b6ab2923ef5171dfb289dc50c9678520ecd",
                               nil];
    }



}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    //An interstitial object can only be used once - so it's useful to automatically load a new one when the current one is dismissed
    [self preLoadInterstitial];
}
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial{

    NSLog(@"full screen ad received");
}

-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{

    
    NSLog(@"full screen Fail To received, will try again decriptiom:%@",error.description);
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(preLoadInterstitial) userInfo:nil repeats:NO];
    
}

#pragma mark - Build Views

-(void)buildUserImageView{

    userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/IMAGESIZE, self.view.frame.size.height/IMAGESIZE)];
    [saveView addSubview:userImageView];
    
    [saveView sendSubviewToBack:userImageView];
    
    userImageView.userInteractionEnabled = NO;
    
    self.rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationImage:)];
    _rotationRecognizer.delegate = self;
    self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    _pinchRecognizer.delegate = self;
    self.panRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panpan:)];
    
    [userImageView addGestureRecognizer:_panRecognizer];
    [userImageView addGestureRecognizer:_pinchRecognizer];
    [userImageView addGestureRecognizer:_rotationRecognizer];

    
    // 半透明图层
    usershadowImageView = [[UIView alloc] initWithFrame:userImageView.frame];
    usershadowImageView.frame = userImageView.frame;
    usershadowImageView.backgroundColor = [UIColor clearColor];
    usershadowImageView.userInteractionEnabled = NO;
    
    tempView = [[UIImageView alloc] initWithFrame:userImageView.frame];
    [usershadowImageView addSubview:tempView];
    
    [usershadowImageView addGestureRecognizer:_panRecognizer];
    [usershadowImageView addGestureRecognizer:_pinchRecognizer];
    [usershadowImageView addGestureRecognizer:_rotationRecognizer];
    [self.view insertSubview:usershadowImageView aboveSubview:imageView];
}

-(void)bulidToolsView
{

    UIView *toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    toolsView.backgroundColor = [UIColor colorWithWhite:.1f alpha:.3f];
    toolsView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:toolsView];
    [self.view bringSubviewToFront:toolsView];
    

    
    // 照片按钮
    getPhotoBtn = [[EditorButton alloc] initWithFrame:CGRectMake(10, 3, 44, 44)];
    [getPhotoBtn setTitle:NSLocalizedString(@"Photo", nil) forState:UIControlStateNormal];
    [getPhotoBtn handleControlWithBlock:^{
        if (!isBGDone) {
            return;
        }
        [self pushedNewBtn];
    }];
    [toolsView addSubview:getPhotoBtn];
    
    //编辑按钮
    closeBtn = [[EditorButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [closeBtn setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    closeBtn.hidden = YES;
    [closeBtn handleControlWithBlock:^{
        editBtn.hidden = NO;
        closeBtn.hidden = YES;
        
        getPhotoBtn.hidden = NO;
        saveBtn.hidden = NO;
        [UIView transitionFromView:closeBtn
                            toView:editBtn
                          duration: 1.f
                           options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut
                        completion:^(BOOL finished) {
                            if (finished) {
                            }
                        }
         ];
        [saturationSlider.superview removeFromSuperview];
        [brightnessSlider.superview removeFromSuperview];
        [contrastSlider.superview removeFromSuperview];
        NSLog(@"saturationSlider:%@",saturationSlider);
        
    }];
//    [toolsView addSubview:closeBtn];
    
    editBtn = [[EditorButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [editBtn setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    [editBtn handleControlWithBlock:^{
        if (!isBGDone) {
            return;
        }
        if (!userImageView.image) {
            alert(NSLocalizedString(@"Need to add a photo first before editing", nil));
            return ;
        }
        [self adjustmentViewBulid];
        closeBtn.hidden = NO;
        editBtn.hidden = YES;
        getPhotoBtn.hidden = YES;
        saveBtn.hidden = YES;
        [UIView transitionFromView:editBtn
                            toView:closeBtn
                          duration: 1.f
                           options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut
                        completion:^(BOOL finished) {
                            if (finished) {
                            }
                        }
         ];

        thumnailImage = [userImageView.image resize:userImageView.frame.size];
    }];
//    [toolsView addSubview:editBtn];
    
    UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-21, 2, 45, 45)];
    [boxView addSubview:closeBtn];
    [boxView addSubview:editBtn];
    
    [toolsView addSubview:boxView];
    
    
    //保存按钮
    saveBtn = [[EditorButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 54, 3, 44, 44)];
    [saveBtn setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [saveBtn handleControlWithBlock:^{
        if (!isBGDone) {
            return;
        }
        [self pushedSaveBtn];
    }];
    [toolsView addSubview:saveBtn];

}

-(void)adjustmentViewBulid{

    saturationSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, 260, 35)];
    [self sliderWithValue:1 minimumValue:0 maximumValue:2 image:@"saturation.png" withSlider:saturationSlider action:@selector(sliderDidChange:)];
    saturationSlider.superview.center = CGPointMake(self.view.width/2, self.view.bottom-80);
    
    
    brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, 260, 35)];
    [self sliderWithValue:0 minimumValue:-1 maximumValue:1 image:@"brightness.png" withSlider:brightnessSlider action:@selector(sliderDidChange:)];
    brightnessSlider.superview.center = CGPointMake(20, saturationSlider.superview.top - 150);
    brightnessSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    
    
    contrastSlider =[[UISlider alloc] initWithFrame:CGRectMake(10, 0, 260, 35)];
    [self sliderWithValue:1 minimumValue:0.5 maximumValue:1.5 image:@"contrast.png" withSlider:contrastSlider action:@selector(sliderDidChange:)];
    contrastSlider.superview.center = CGPointMake(300, brightnessSlider.superview.center.y);
    contrastSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);

}

#pragma mark- action


-(void)pushedNewBtn{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Choose Photo", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Use Photo from Library", nil),NSLocalizedString(@"Take Photo with Camera", nil), nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view.window];
}

- (void)pushedSaveBtn
{
    if(userImageView.image){
        NSArray *excludedActivityTypes = @[UIActivityTypePostToVimeo,UIActivityTypeMessage];
//        NSString *str = [NSString stringWithFormat:@"%@ http://itunes.apple.com/app/iface+/id904153091?mt=8",NSLocalizedString(@"iFace+ make your life more colorful", nil)];
        NSString *str = [NSString stringWithFormat:@"%@ http://goo.gl/L9jNZw",NSLocalizedString(@"iFace+ make your life more colorful", nil)];
        
        UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[str,[self mergeImage]] applicationActivities:nil];
        activityView.excludedActivityTypes = excludedActivityTypes;
        activityView.completionHandler = ^(NSString *activityType, BOOL completed){
            // ad control
            NSInteger adnum = [[[NSUserDefaults standardUserDefaults] objectForKey:@"EditerVCADControl"] intValue];
            if (adnum < EDITVCADCOUNT) {
                adnum++;
                [[NSUserDefaults standardUserDefaults] setInteger:adnum forKey:@"EditerVCADControl"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                if (interstitial_) {
                    if (interstitial_.isReady) {
                        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"EditerVCADControl"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [interstitial_ presentFromRootViewController:self];
                        if (interstitial_.hasBeenUsed) {
                            [self preLoadInterstitial];
                        }
                    }

                }

                
            }
            

            
            // rate count
            NSInteger launchCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"saveCount"] intValue];
            if (launchCount < SAVEMAXCOUNT) {
                launchCount++;
                [[NSUserDefaults standardUserDefaults] setInteger:launchCount forKey:@"saveCount"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            if(completed && [activityType isEqualToString:UIActivityTypeSaveToCameraRoll]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Saved successfully", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
                [alert show];
                
            }else if ([activityType isEqualToString:UIActivityTypePostToFacebook]||[activityType isEqualToString:UIActivityTypePostToTwitter]||[activityType isEqualToString:UIActivityTypePostToWeibo]||[activityType isEqualToString:UIActivityTypePostToTencentWeibo]||[activityType isEqualToString:UIActivityTypePostToFlickr]){
                alert(NSLocalizedString(@"Send Successfully",nil));
            }
        };
        
        [self presentViewController:activityView animated:YES completion:nil];
    }
    else{
        [self pushedNewBtn];
    }
}

-(UIImage *)mergeImage
{
    UIGraphicsBeginImageContext(saveView.bounds.size);
    [saveView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *MergedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return MergedImage;

}


//TODO: slider

- (void)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max image:(NSString*)imageName withSlider:(UISlider*)slider action:(SEL)action
{
    [slider setThumbImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, slider.height)];
    container.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    container.layer.cornerRadius = slider.height/2;
    
    slider.continuous = YES;
    [slider addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    
    slider.maximumValue = max;
    slider.minimumValue = min;
    slider.value = value;
    
    [container addSubview:slider];
    [self.view insertSubview:container aboveSubview:tempView];
    
}



- (void)sliderDidChange:(UISlider*)sender
{
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    inProgress = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self filteredImage:thumnailImage];
        [userImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        inProgress = NO;
    });
}

- (UIImage*)filteredImage:(UIImage*)image
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:saturationSlider.value] forKey:@"inputSaturation"];
    
    filter = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
    [filter setDefaults];
    CGFloat brightness = 2*brightnessSlider.value;
    [filter setValue:[NSNumber numberWithFloat:brightness] forKey:@"inputEV"];
    
    filter = [CIFilter filterWithName:@"CIGammaAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
    [filter setDefaults];
    CGFloat contrast   = contrastSlider.value*contrastSlider.value;
    [filter setValue:[NSNumber numberWithFloat:contrast] forKey:@"inputPower"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    return result;
}


#pragma mark UIGestureRecognizer Delegate

- (BOOL)handleGestureState:(UIGestureRecognizerState)state
{
    BOOL handle = YES;
    switch (state) {
        case UIGestureRecognizerStateBegan:
            self.gestureCount++;
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            self.gestureCount--;
            handle = NO;
            if(self.gestureCount == 0) {
                CGFloat scale = self.scale;
                if(self.minimumScale != 0 && self.scale < self.minimumScale) {
                    scale = self.minimumScale;
                } else if(self.maximumScale != 0 && self.scale > self.maximumScale) {
                    scale = self.maximumScale;
                }
                if(scale != self.scale) {
                    CGFloat deltaX = self.scaleCenter.x-userImageView.bounds.size.width/2.0;
                    CGFloat deltaY = self.scaleCenter.y-userImageView.bounds.size.height/2.0;
                    
                    CGAffineTransform transform =  CGAffineTransformTranslate(userImageView.transform, deltaX, deltaY);
                    transform = CGAffineTransformScale(transform, scale/self.scale , scale/self.scale);
                    transform = CGAffineTransformTranslate(transform, -deltaX, -deltaY);
                    self.view.userInteractionEnabled = NO;
                    [UIView animateWithDuration:kAnimationIntervalTransform
                                          delay:0
                                        options:UIViewAnimationCurveEaseOut
                                     animations:^{
                        userImageView.transform = transform;
                    } completion:^(BOOL finished) {
                        self.view.userInteractionEnabled = YES;
                        self.scale = scale;
                    }];
                    
                }
            }
        } break;
        default:
            break;
    }
    return handle;
}

- (void)panpan:(UIPanGestureRecognizer *)recognizer {
//    [self.view sendSubviewToBack:self.userImageView];
//    CGPoint location = [recognizer locationInView:self.view];
//    recognizer.view.center = CGPointMake(location.x,  location.y);
    if([self handleGestureState:recognizer.state]) {
        CGPoint translation = [recognizer translationInView:userImageView];
        CGAffineTransform transform = CGAffineTransformTranslate(userImageView.transform, translation.x, translation.y);
        userImageView.transform = transform;
        usershadowImageView.transform = transform;
        
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded){
        
        tempView.alpha = 0.f;
    }
}

- (void)rotationImage:(UIRotationGestureRecognizer*)recognizer {
//    [self.view sendSubviewToBack:self.userImageView];

    if([self handleGestureState:recognizer.state]) {
        if(recognizer.state == UIGestureRecognizerStateBegan){
            self.rotationCenter = self.touchCenter;
        }
        CGFloat deltaX = self.rotationCenter.x-userImageView.bounds.size.width/2;
        CGFloat deltaY = self.rotationCenter.y-userImageView.bounds.size.height/2;
        
        CGAffineTransform transform =  CGAffineTransformTranslate(userImageView.transform,deltaX,deltaY);
        transform = CGAffineTransformRotate(transform, recognizer.rotation);
        transform = CGAffineTransformTranslate(transform, -deltaX, -deltaY);
        userImageView.transform = transform;
        usershadowImageView.transform = transform;
        
        recognizer.rotation = 0;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded){
        
        tempView.alpha = 0.f;
    }
}
- (void)changeImage:(UIPinchGestureRecognizer*)recognizer {
//    [self.view sendSubviewToBack:self.userImageView];
    if([self handleGestureState:recognizer.state]) {
        if(recognizer.state == UIGestureRecognizerStateBegan){
            self.scaleCenter = self.touchCenter;
        }
        CGFloat deltaX = self.scaleCenter.x-userImageView.bounds.size.width/2.0;
        CGFloat deltaY = self.scaleCenter.y-userImageView.bounds.size.height/2.0;
        
        CGAffineTransform transform =  CGAffineTransformTranslate(userImageView.transform, deltaX, deltaY);
        transform = CGAffineTransformScale(transform, recognizer.scale, recognizer.scale);
        transform = CGAffineTransformTranslate(transform, -deltaX, -deltaY);
        self.scale *= recognizer.scale;
        userImageView.transform = transform;
        usershadowImageView.transform = transform;
        
        recognizer.scale = 1;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded){
        
        tempView.alpha = 0.f;
    }
    
}
- (void)handleTouches:(NSSet*)touches
{
    self.touchCenter = CGPointZero;
    if(touches.count < 2) return;
    
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UITouch *touch = (UITouch*)obj;
        CGPoint touchLocation = [touch locationInView:userImageView];
        self.touchCenter = CGPointMake(self.touchCenter.x + touchLocation.x, self.touchCenter.y +touchLocation.y);
    }];
    self.touchCenter = CGPointMake(self.touchCenter.x/touches.count, self.touchCenter.y/touches.count);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:[event allTouches]];
    if (tempView.alpha == .0f) {
        tempView.alpha = 0.1f;
    }

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:[event allTouches]];
    if (tempView.alpha == .0f) {
        tempView.alpha = 0.1f;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:[event allTouches]];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:[event allTouches]];
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


#pragma mark - photo contorl

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 相册取
    if (buttonIndex == 0) {

        if (kXHISIPAD) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;//是否允许编辑
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            /*
             如果从一个导航按钮处呈现，使用：
             presentPopoverFromBarButtonItem:permittedArrowDirections:animated:；
             如果要从一个视图出呈现，使用：
             presentPopoverFromRect:inView:permittedArrowDirections:animated:
             
             如果设备旋转以后，位置定位错误需要在父视图控制器的下面方法里面重新定位：
             didRotateFromInterfaceOrientation:（在这个方法体里面重新设置rect）
             然后再次调用：
             - (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
             */
            //UIPopoverController只能在ipad设备上面使用；作用是用于显示临时内容，特点是总是显示在当前视图最前端，当单击界面的其他地方时自动消失。
            self.popVC = [[UIPopoverController alloc] initWithContentViewController:picker];
            //permittedArrowDirections 设置箭头方向
            [_popVC presentPopoverFromRect:CGRectMake(0, 0, 300, 300) inView:getPhotoBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else{
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
                
            }
            pickerImage.delegate = self;
            pickerImage.allowsEditing = NO;
            [self presentViewController:pickerImage animated:YES completion:^{
                
            }];
        }
    }else if (buttonIndex == 1){   //照片
    
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = NO;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }

}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    // Handle the end of the image write process
    if (error)
        alert([NSString stringWithFormat:@"Error writing to photo album: %@",
               [error localizedDescription]]);
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    userImageView.image = image;
    [userImageView setUserInteractionEnabled:YES];
    tempView.alpha = .1f;
    tempView.image = userImageView.image;

    [usershadowImageView setUserInteractionEnabled:YES];
    
    //image from camera storage
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    NSLog(@"info:%@",info);
}

-(NSUInteger)supportedInterfaceOrientations{

    return UIInterfaceOrientationMaskPortraitUpsideDown | UIInterfaceOrientationMaskPortrait;
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
