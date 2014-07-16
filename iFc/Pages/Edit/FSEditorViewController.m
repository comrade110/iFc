//
//  FSEditorViewController.m
//  iFc
//
//  Created by chx on 14/7/15.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "FSEditorViewController.h"

@interface FSEditorViewController (){

    SEL showProgress;

}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFImageView *imageView = [[PFImageView alloc] initWithFrame:self.view.frame];
    imageView.image = _bgImg;
    imageView.file = [[SinglePicManager manager] entity][@"imageData"];
    
    DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 40.0f, 40.0f)];
    progressView.center = imageView.center;
    progressView.progress=0.0f;
    progressView.hidden = YES;
    [imageView addSubview:progressView];
    
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

    
    [imageView.file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            imageView.image = [UIImage imageWithData:data];
        }
        [progressView removeFromSuperview];
    } progressBlock:^(int percentDone) {
        progressView.progress=(float)percentDone/100;
    }];
    [self.view addSubview:imageView];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.center = self.view.center;
    [btn setTitle:@"back" forState:UIControlStateNormal];
    [btn handleControlWithBlock:^{
        [self dismissFlipWithCompletion:NULL];
        
    }];
    
    [self.view addSubview:btn];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
