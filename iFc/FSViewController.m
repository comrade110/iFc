//
//  FSViewController.m
//  iFc
//
//  Created by xiang-chen on 14-7-14.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "FSViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "FSSubTypeViewController.h"
#import "InstagramCollectionViewController.h"
#import "InstagramThumbnailCollectionViewController.h"

@interface FSViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    
    UIAlertView *purchaseAlertView;
}

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *imageArr;
@property(nonatomic,strong) NSArray *quaryArr;

@end

@implementation FSViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    if ([UIApplication sharedApplication].statusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor mainBgColor];
    self.title = NSLocalizedString(@"Home", nil);
//  rate control
    
    [self setupLeftMenuButton];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView =nil;

    [self.view addSubview:_tableView];
    self.imageArr = @[
                      @"peple_bg",
                      @"animal_bg"
                      ];
    self.quaryArr = @[
                      NSLocalizedString(@"Human", nil),
                      NSLocalizedString(@"Animals", nil)
                      ];
    
//    [self removeAds];
//    PFQuery *query = [PFQuery queryWithClassName:@"Type"];
//    [query whereKey:@"fid" equalTo:@0];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            weakSelf.quaryArr = [[NSArray alloc] initWithArray:objects];
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %d scores.", objects.count);
//            // Do something with the found objects
//            [weakSelf.tableView reloadData];
//        } else {
//            // Log details of the failure
//            alert(@"Connection failed, please try again later.");
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//        [indicatorView stopAnimating];
//    }];
//    
	// Do any additional setup after loading the view, typically from a nib.
    
    [[CJPAdController sharedInstance] removeAds];
}





-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

#pragma mark - alertview

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == purchaseAlertView) {
        switch (buttonIndex) {
            case 0:
                NSLog(@"cancel");
                break;
            case 1:{
                // 购买
                NSLog(@"case 1");
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [IAPContorl showAlertByID:Product_NOiAd withCompletionBlock:^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
            }
                
                break;
                
            default:
                break;
        }
        
    }
    
    
}
-(void)viewWillLayoutSubviews{

    [_tableView reloadData];

}


#pragma mark - tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return _quaryArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return kXHISIPAD?270.f:180.f;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return kXHISIPAD?30.f:25.f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1 ){
        return [[UIView alloc] init];
    }else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.backgroundColor = [UIColor clearColor];

    // Configure the cell
    BOOL isPortrait = UIInterfaceOrientationIsPortrait(self.interfaceOrientation);
    
    CGFloat scale = kXHISIPAD?1.5:1;

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(kXHISIPAD?isPortrait?_tableView.width/2-125*scale:_tableView.height/2-125*scale:_tableView.width/2-125*scale, 0, 250*scale, 150*scale)];
    backView.backgroundColor = [UIColor mainCellColor];
    backView.layer.cornerRadius = 5.f*scale;
    backView.layer.borderWidth = .5f*scale;
    backView.layer.borderColor = [[UIColor colorWithWhite:220./255. alpha:1.f] CGColor];
    backView.layer.shadowOffset = CGSizeMake(0, 3);
    backView.layer.shadowOpacity = .1f;
    backView.layer.shadowColor = [UIColor grayColor].CGColor;
    
    UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250*scale, 150*scale)];
    boxView.layer.cornerRadius = 5.f*scale;
    boxView.layer.borderWidth = .5f*scale;
    boxView.layer.borderColor = [[UIColor clearColor] CGColor];
    boxView.clipsToBounds = YES;
    boxView.layer.masksToBounds = YES;
    [backView addSubview:boxView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height - 40*scale);
    imageView.image = [UIImage imageNamed:_imageArr[indexPath.row]];
    [boxView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 110*scale, 250*scale, 40*scale)];
    label.font = [UIFont fontWithName:@"Avenir-LightOblique" size:16.f*scale];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = _quaryArr[indexPath.row];

    
    [backView addSubview:label];
    
    [cell.contentView addSubview:backView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *tempView = [[UIView alloc] init];
    [cell setBackgroundView:tempView];
    [cell setBackgroundColor:[UIColor clearColor]];
    
//    UIImageView *jiaobiaoView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.left-3, backView.top-3, 151/2, 147/2)];
//    NSString *curLang = [FSConfig getCurrentLanguage] ;
//    if ([curLang isEqualToString:@"zh-Hans"]||[curLang isEqualToString:@"zh-Hant"]||[curLang isEqualToString:@"ja"]) {
//        jiaobiaoView.image = [UIImage imageNamed:@"jiaobiao_cn"];
//    }else{
//        jiaobiaoView.image = [UIImage imageNamed:@"jiaobiao_en"];
//    }
//    [cell addSubview:jiaobiaoView];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
        
            FSSubTypeViewController *subTypeVC = [[FSSubTypeViewController alloc] init];
            subTypeVC.fid = [NSNumber numberWithInt:(int)indexPath.row+1];
            [self.navigationController pushViewController:subTypeVC animated:YES];
        }
            
            break;
        case 1:{
            InstagramCollectionViewController *instagramCollectionViewController = [InstagramThumbnailCollectionViewController sharedInstagramCollectionViewControllerWithObjectId:@"FaA6sJ2Avt"];
            NSString *titleStr = NSLocalizedString(@"Animal", nil);
            instagramCollectionViewController.title = titleStr;
            [self.navigationController pushViewController:instagramCollectionViewController animated:YES];
        }
            break;
        default:
            break;
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
