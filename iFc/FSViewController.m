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

@interface FSViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *imageArr;
@property(nonatomic,strong) NSArray *quaryArr;

@end

@implementation FSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor mainBgColor];
    self.title = @"Home";
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self setupLeftMenuButton];
//    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 23)];
//    [leftBtn setImage:[UIImage imageNamed:@"pullDrawer"] forState:UIControlStateNormal];
//    [leftBtn handleControlWithBlock:^{
//        
//    }];
//    
//    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithCustomView:leftBtn];
//    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableView];
    self.imageArr = @[
                      @"peple_bg",
                      @"animal_bg"
                      ];
    self.quaryArr = @[
                      NSLocalizedString(@"normal", nil),
                      NSLocalizedString(@"animal", nil)
                      ];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return _quaryArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 190.f;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];

    // Configure the cell
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(35.f, 0, 250, 150)];
    backView.backgroundColor = [UIColor mainCellColor];
    backView.layer.cornerRadius = 5.f;
    backView.layer.borderWidth = .5f;
    backView.layer.borderColor = [[UIColor colorWithWhite:220./255. alpha:1.f] CGColor];
    backView.layer.shadowOffset = CGSizeMake(0, 3);
    backView.layer.shadowOpacity = .1f;
    backView.layer.shadowColor = [UIColor grayColor].CGColor;
    
    UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    boxView.layer.cornerRadius = 5.f;
    boxView.layer.borderWidth = .5f;
    boxView.layer.borderColor = [[UIColor clearColor] CGColor];
    boxView.clipsToBounds = YES;
    boxView.layer.masksToBounds = YES;
    [backView addSubview:boxView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height - 40);
    imageView.image = [UIImage imageNamed:_imageArr[indexPath.row]];
    [boxView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 250, 40)];
    label.font = [UIFont fontWithName:@"Avenir-LightOblique" size:16.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.text = _quaryArr[indexPath.row];

    
    [backView addSubview:label];
    
    [cell.contentView addSubview:backView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    FSSubTypeViewController *subTypeVC = [[FSSubTypeViewController alloc] init];
    subTypeVC.fid = [NSNumber numberWithInt:(int)indexPath.row+1];
    [self.navigationController pushViewController:subTypeVC animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
