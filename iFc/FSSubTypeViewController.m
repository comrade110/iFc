//
//  FSSubTypeViewController.m
//  iFc
//
//  Created by xiang-chen on 14-7-14.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "FSSubTypeViewController.h"
#import "JBParallaxCell.h"
#import "InstagramCollectionViewController.h"
#import "InstagramThumbnailCollectionViewController.h"

@interface FSSubTypeViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *quaryArr;

@end

@implementation FSSubTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    if ([UIApplication sharedApplication].statusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"SubType Screen";
    self.view.backgroundColor = [UIColor mainBgColor];
    

    [self syncParseData];
    
    NSLog(@"self.fid:%@",self.fid);
    // Do any additional setup after loading the view.

}


-(void)syncParseData{
    
    WEAKSELF
    PFQuery *query = [PFQuery queryWithClassName:@"Type"];
    [query whereKey:@"fid" equalTo:self.fid];
    [query orderByAscending:@"priority"];
    MONActivityIndicatorView *indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.center = CGPointMake(self.view.center.x, self.view.center.y-64);
    [self.view addSubview:indicatorView];
    [indicatorView startAnimating];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            weakSelf.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
            weakSelf.tableView.delegate = self;
            weakSelf.tableView.dataSource = self;
            weakSelf.tableView.separatorColor = [UIColor colorWithRed:140./255. green:153./255. blue:169./255. alpha:.5f];
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            weakSelf.tableView.backgroundColor = [UIColor clearColor];
            
            [self.view addSubview:weakSelf.tableView];
            weakSelf.quaryArr = objects;
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            [weakSelf.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            FSErrorView *errorView = [[FSErrorView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, [[UIScreen mainScreen]bounds].size.height-64) withAciontBlock:^{
                [_tableView removeFromSuperview];
                [self syncParseData];
            }];
            [self.view addSubview:errorView];
        }
        [indicatorView stopAnimating];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.quaryArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 85.f;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"parallaxCell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else{
    
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
    }
    cell.backgroundColor = [UIColor clearColor];
    
    PFObject *object = _quaryArr[indexPath.row];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 179, 85)];
    label.textColor = [UIColor colorWithRed:140./255. green:153./255. blue:169./255. alpha:1.f];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fsFontWithSize:16.f];
    if ([[FSConfig getCurrentLanguage] isEqualToString:@"zh-Hans"]) {
        label.text = object[@"name_cn"];
    }else if ([[FSConfig getCurrentLanguage] isEqualToString:@"zh-Hant"]){
        label.text = object[@"name_hk"];
    }else{
        label.text = object[@"name_en"];
    }
    [cell.contentView addSubview:label];
    PFImageView *imageView = [[PFImageView alloc] initWithFrame:CGRectMake(10, 10, 46.5f, 65.f)];
    imageView.image = [UIImage imageNamed:@"placeholder"];
    imageView.file = (PFFile*)object[@"imageFile"];
    [imageView loadInBackground:^(UIImage *image, NSError *error) {
    }];
    [cell.contentView addSubview:imageView];
    [cell.contentView sendSubviewToBack:boxView];
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    PFObject *object = _quaryArr[indexPath.row];
    
     InstagramCollectionViewController *instagramCollectionViewController = [InstagramThumbnailCollectionViewController sharedInstagramCollectionViewControllerWithObjectId:object.objectId];
    NSString *titleStr = nil;
    if ([[FSConfig getCurrentLanguage] isEqualToString:@"zh-Hans"]) {
        titleStr = object[@"name_cn"];
    }else if ([[FSConfig getCurrentLanguage] isEqualToString:@"zh-Hant"]){
        titleStr = object[@"name_hk"];
    }else{
        titleStr= object[@"name_en"];
    }
    instagramCollectionViewController.title = titleStr;
    [self.navigationController pushViewController:instagramCollectionViewController animated:YES];

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
