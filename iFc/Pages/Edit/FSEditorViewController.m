//
//  FSEditorViewController.m
//  iFc
//
//  Created by chx on 14/7/15.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "FSEditorViewController.h"

@interface FSEditorViewController ()

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
