//
//  FSCopyrightViewController.m
//  iFc
//
//  Created by xiang-chen on 14-8-5.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "FSCopyrightViewController.h"
#import "MMDrawerBarButtonItem.h"

@interface FSCopyrightViewController ()

@end

@implementation FSCopyrightViewController

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
    
    self.title = @"Copyright";
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    self.view.backgroundColor = [UIColor mainBgColor];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 30)];
    titleL.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = [UIColor colorWithWhite:160./255. alpha:1.f];
    titleL.font = [UIFont boldSystemFontOfSize:18.f];
    titleL.text = NSLocalizedString(@"iFace+", nil);
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 55, self.view.width - 40, self.view.height-60)];
    textView.editable = NO;
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor colorWithWhite:160./255. alpha:1.f];
    textView.font = [UIFont systemFontOfSize:12.f];
    textView.text = NSLocalizedString(@"  The App iFace+ is currently only available on iOS Device.We don't assume any responsibility that you use it on other phone models.\n\nWhen downloading and using the GPRS dataflow generated will be charged by your operator.\n\nSome of our images are from the Internet.and the copyright belongs to their original artists.Any unauthorized use will be prosecuted.We have no responsibility for any harm that you may cause to others and yourself.", nil);
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:textView];
    
    UILabel *copyrightL = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - 30, self.view.width, 30)];
    copyrightL.backgroundColor = [UIColor clearColor];
    copyrightL.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    copyrightL.textAlignment = NSTextAlignmentCenter;
    copyrightL.textColor = [UIColor colorWithWhite:200./255. alpha:1.f];
    copyrightL.font = [UIFont systemFontOfSize:10.f];
    copyrightL.text = @"Copyright © 2014 chxstudio";
    
    [self.view addSubview:copyrightL];
    
    // Do any additional setup after loading the view.
}

-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
