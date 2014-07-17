//
//  FSMenuViewController.m
//  gsc
//
//  Created by xiang-chen on 14-7-3.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "FSMenuViewController.h"

@interface FSMenuViewController ()

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *menuArray;

@end

@implementation FSMenuViewController

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
//    self.view.backgroundColor = [UIColor colorWithWhite:1.f/255.f alpha:1.f];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithWhite:60.f/255.f alpha:1.f];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    self.menuArray = @[@"Home",@"UserCenter",@"About",@"History",@"Rate",@"Setting"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [self.menuArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.menuArray[indexPath.section];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont fsFontWithSize:16.f];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:{
            [self.mm_drawerController setCenterViewController:[NSClassFromString(@"FSHomeViewController") new] withFullCloseAnimation:YES completion:^(BOOL b) {
                
            }];
        }
            break;
        case 1:{
            [self.mm_drawerController setCenterViewController:[NSClassFromString(@"FSBasicViewController") new] withFullCloseAnimation:YES completion:^(BOOL b) {
                
            }];
        }
            break;
        default:
            break;
    }
    if (indexPath.section == 1) {

    }

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
