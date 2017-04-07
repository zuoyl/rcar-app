//
//  FavoriteCommodityViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 12/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "FavoriteCommodityViewController.h"
#import "FavoriteModel.h"
#import "SellerCommodityCell.h"
#import "FavoriteRepository.h"
#import "SWTableViewCell.h"


@interface FavoriteCommodityViewController ()<SWTableViewCellDelegate>

@end

@implementation FavoriteCommodityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self.tableView registerClass:[SellerCommodityCell class] forCellReuseIdentifier:@"SellerCommodityCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // clear noused rows
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}


- (void)reloadData:(id)sender {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FavoriteRepository *repository = [FavoriteRepository sharedClient];
    // Return the number of rows in the section.
    return [repository count:FavoriteType_Commodity];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  70.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"SellerCommodityCell";
    
    SellerCommodityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
        cell = [[SellerCommodityCell alloc]initWithFrame:[self.tableView rectForRowAtIndexPath:indexPath]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    FavoriteRepository *repository = [FavoriteRepository sharedClient];
    [cell setModel:[repository itemAtIndex:indexPath.row type:FavoriteType_Commodity]];
    
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    [buttons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    [cell setRightUtilityButtons:buttons WithButtonWidth:50];
    cell.delegate = self;
    cell.path = indexPath;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SellerCommodityDetail"];
    controller.hidesBottomBarWhenPushed = YES;
    
    FavoriteRepository *repository = [FavoriteRepository sharedClient];
    SellerCommodityModel *commodity = [repository itemAtIndex:indexPath.row type:FavoriteType_Commodity];
    [controller setValue:commodity forKey:@"model"];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    // delete notification from notifyCenter
    SellerCommodityCell *itemCell = (SellerCommodityCell *)cell;
    FavoriteRepository *repository = [FavoriteRepository sharedClient];
   [repository removeItem:itemCell.path.row type:FavoriteType_Commodity];
}

@end
