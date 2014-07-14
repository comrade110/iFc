//
//  FSSubTypeViewController.m
//  iFc
//
//  Created by xiang-chen on 14-7-14.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "FSSubTypeViewController.h"
#import "JBParallaxCell.h"

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrollViewDidScroll:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableView];
    
    WEAKSELF
    NSLog(@"self.fid:%@",self.fid);
    // Do any additional setup after loading the view.
    PFQuery *query = [PFQuery queryWithClassName:@"Type"];
    [query whereKey:@"fid" equalTo:self.fid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            weakSelf.quaryArr = [[NSArray alloc] initWithArray:objects];
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            [weakSelf.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
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

    return 130.f;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"parallaxCell";
    JBParallaxCell *cell = [[JBParallaxCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    
    PFObject *object = _quaryArr[indexPath.row];
    
    UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    
//    cell.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 69, 179, 21)];
    cell.textLabel.frame =CGRectMake(10, 69, 179, 21);
    cell.textLabel.textColor = [UIColor whiteColor];
    if ([[FSConfig getCurrentLanguage] isEqualToString:@"zh-Hans"]) {
        cell.titleLabel.text = object[@"name_cn"];
    }else if ([[FSConfig getCurrentLanguage] isEqualToString:@"zh-Hant"]){
        cell.titleLabel.text = object[@"name_hk"];
    }else{
        cell.titleLabel.text = @"name_en";
    }

    cell.parallaxImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -41, cell.frame.size.width, 200)];
    cell.parallaxImage.image = [UIImage imageNamed:@"placeholder2"];
    [cell.parallaxImage sendSubviewToBack:cell.parallaxImage];
    [cell.contentView addSubview:boxView];
//    [boxView addSubview:cell.parallaxImage];
    [cell.contentView sendSubviewToBack:boxView];
    
    
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get visible cells on table view.
    NSArray *visibleCells = [self.tableView visibleCells];
    
    for (JBParallaxCell *cell in visibleCells) {
        [cell cellOnTableView:self.tableView didScrollOnView:self.view];
    }
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
