//
//  FSEditorViewController.m
//  iFc
//
//  Created by chx on 14/7/15.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "FSEditorViewController.h"
#import "EditorButton.h"

#define IMAGESIZE 2

static const NSTimeInterval kAnimationIntervalTransform = 0.2;

@interface FSEditorViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>{

    SEL showProgress;

}
@property(nonatomic,strong) PFImageView *imageView;
@property(nonatomic,strong) UIImageView *userImageView;
@property(nonatomic,strong) UIImageView *usershadowImageView;
@property (retain, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (retain, nonatomic) UIRotationGestureRecognizer *rotationRecognizer;
@property (retain, nonatomic) UIPinchGestureRecognizer *pinchRecognizer;


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

     [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView = [[PFImageView alloc] initWithFrame:self.view.frame];
    _imageView.image = _bgImg;
    _imageView.file = [[SinglePicManager manager] entity][@"imageData"];
    
    DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 40.0f, 40.0f)];
    progressView.center = _imageView.center;
    progressView.progress=0.0f;
    progressView.hidden = YES;
    [_imageView addSubview:progressView];
    
    //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
    //设置时间为2
    double delayInSeconds = 0.8;
    //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //推迟两纳秒执行
    dispatch_queue_t concurrentQueue =dispatch_get_main_queue();
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        progressView.hidden = NO;
    });

    WEAKSELF
    [_imageView.file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            weakSelf.imageView.image = [UIImage imageWithData:data];
        }
        [progressView removeFromSuperview];
    } progressBlock:^(int percentDone) {
        progressView.progress=(float)percentDone/100;
    }];
    [self.view addSubview:weakSelf.imageView];
    
    //用户导入的图片
    [self buildUserImageView];
    
    //  底部工具栏
    [self bulidToolsView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buildUserImageView{

    self.userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/IMAGESIZE, self.view.frame.size.height/IMAGESIZE)];
    [self.view addSubview:_userImageView];
    
    [self.view sendSubviewToBack:self.userImageView];
    
    self.userImageView.userInteractionEnabled = NO;
    
    self.rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationImage:)];
    _rotationRecognizer.delegate = self;
    self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    _pinchRecognizer.delegate = self;
    self.panRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panpan:)];
    
    [self.userImageView addGestureRecognizer:_panRecognizer];
    [self.userImageView addGestureRecognizer:_pinchRecognizer];
    [self.userImageView addGestureRecognizer:_rotationRecognizer];

    
    // 半透明图层
    self.usershadowImageView = [[UIImageView alloc] initWithFrame:self.userImageView.frame];
    self.usershadowImageView.frame = _userImageView.frame;
    self.usershadowImageView.alpha = .2f;
    self.usershadowImageView.userInteractionEnabled = NO;
    [self.usershadowImageView addGestureRecognizer:_panRecognizer];
    [self.usershadowImageView addGestureRecognizer:_pinchRecognizer];
    [self.usershadowImageView addGestureRecognizer:_rotationRecognizer];
    [self.view insertSubview:self.usershadowImageView aboveSubview:_imageView];
}

-(void)bulidToolsView
{

    UIView *toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    toolsView.backgroundColor = [UIColor colorWithWhite:.1f alpha:.3f];
    toolsView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:toolsView];
    [self.view bringSubviewToFront:toolsView];
    
    
    // 返回按钮
    EditorButton *backBtn = [[EditorButton alloc] initWithFrame:CGRectMake(10, 3, 44, 44)];
    [backBtn setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    [toolsView addSubview:backBtn];
    [backBtn handleControlWithBlock:^{
        [self dismissFlipWithCompletion:NULL];
        
    }];
    
    // 照片按钮
    EditorButton *getPhotoBtn = [[EditorButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-22, 3, 44, 44)];
    [getPhotoBtn setTitle:NSLocalizedString(@"Photo", nil) forState:UIControlStateNormal];
    [getPhotoBtn handleControlWithBlock:^{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Photo from Library",@"Take Photo with Camera", nil];
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }];
    [toolsView addSubview:getPhotoBtn];
    
    //保存按钮
    EditorButton *saveBtn = [[EditorButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 54, 3, 44, 44)];
    [saveBtn setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [toolsView addSubview:saveBtn];

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
                    CGFloat deltaX = self.scaleCenter.x-self.userImageView.bounds.size.width/2.0;
                    CGFloat deltaY = self.scaleCenter.y-self.userImageView.bounds.size.height/2.0;
                    
                    CGAffineTransform transform =  CGAffineTransformTranslate(self.userImageView.transform, deltaX, deltaY);
                    transform = CGAffineTransformScale(transform, scale/self.scale , scale/self.scale);
                    transform = CGAffineTransformTranslate(transform, -deltaX, -deltaY);
                    self.view.userInteractionEnabled = NO;
                    [UIView animateWithDuration:kAnimationIntervalTransform
                                          delay:0
                                        options:UIViewAnimationCurveEaseOut
                                     animations:^{
                        self.userImageView.transform = transform;
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
        CGPoint translation = [recognizer translationInView:self.userImageView];
        CGAffineTransform transform = CGAffineTransformTranslate( self.userImageView.transform, translation.x, translation.y);
        self.userImageView.transform = transform;
        self.usershadowImageView.transform = transform;
        
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    
}

- (void)rotationImage:(UIRotationGestureRecognizer*)recognizer {
//    [self.view sendSubviewToBack:self.userImageView];

    if([self handleGestureState:recognizer.state]) {
        if(recognizer.state == UIGestureRecognizerStateBegan){
            self.rotationCenter = self.touchCenter;
        }
        CGFloat deltaX = self.rotationCenter.x-self.userImageView.bounds.size.width/2;
        CGFloat deltaY = self.rotationCenter.y-self.userImageView.bounds.size.height/2;
        
        CGAffineTransform transform =  CGAffineTransformTranslate(self.userImageView.transform,deltaX,deltaY);
        transform = CGAffineTransformRotate(transform, recognizer.rotation);
        transform = CGAffineTransformTranslate(transform, -deltaX, -deltaY);
        self.userImageView.transform = transform;
        self.usershadowImageView.transform = transform;
        
        recognizer.rotation = 0;
    }
}
- (void)changeImage:(UIPinchGestureRecognizer*)recognizer {
//    [self.view sendSubviewToBack:self.userImageView];
    if([self handleGestureState:recognizer.state]) {
        if(recognizer.state == UIGestureRecognizerStateBegan){
            self.scaleCenter = self.touchCenter;
        }
        CGFloat deltaX = self.scaleCenter.x-self.userImageView.bounds.size.width/2.0;
        CGFloat deltaY = self.scaleCenter.y-self.userImageView.bounds.size.height/2.0;
        
        CGAffineTransform transform =  CGAffineTransformTranslate(self.userImageView.transform, deltaX, deltaY);
        transform = CGAffineTransformScale(transform, recognizer.scale, recognizer.scale);
        transform = CGAffineTransformTranslate(transform, -deltaX, -deltaY);
        self.scale *= recognizer.scale;
        self.userImageView.transform = transform;
        self.usershadowImageView.transform = transform;
        
        recognizer.scale = 1;
    }
    
}
- (void)handleTouches:(NSSet*)touches
{
    self.touchCenter = CGPointZero;
    if(touches.count < 2) return;
    
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UITouch *touch = (UITouch*)obj;
        CGPoint touchLocation = [touch locationInView:self.userImageView];
        self.touchCenter = CGPointMake(self.touchCenter.x + touchLocation.x, self.touchCenter.y +touchLocation.y);
    }];
    self.touchCenter = CGPointMake(self.touchCenter.x/touches.count, self.touchCenter.y/touches.count);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:[event allTouches]];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:[event allTouches]];
    self.usershadowImageView.alpha = .2f;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:[event allTouches]];
    self.usershadowImageView.alpha = 0.001f;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:[event allTouches]];
    self.usershadowImageView.hidden = 0.001f;
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    self.usershadowImageView.alpha = .2f;
}
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{

}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 相册取
    if (buttonIndex == 0) {

        if (kXHISIPAD) {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;//是否允许编辑
            picker.sourceType = sourceType;
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
            UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:picker];
            //permittedArrowDirections 设置箭头方向
            [popover presentPopoverFromRect:CGRectMake(0, 0, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    self.userImageView.image = info[@"UIImagePickerControllerOriginalImage"];
    [self.userImageView setUserInteractionEnabled:YES];
    self.usershadowImageView.image = self.userImageView.image;
    [self.usershadowImageView setUserInteractionEnabled:YES];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    NSLog(@"info:%@",info);
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
