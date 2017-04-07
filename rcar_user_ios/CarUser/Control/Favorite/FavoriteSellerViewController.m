//
//  FavoriteSellerViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 12/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "FavoriteSellerViewController.h"
#import "FavoriteModel.h"
#import "SellerInfoCell.h"
#import "FavoriteRepository.h"
#import "SellerInfoViewController.h"
#import "SWTableViewCell.h"
#import "SellerInfoViewController.h"


@interface FavoriteSellerViewController () <SWTableViewCellDelegate>

@end

@implementation FavoriteSellerViewController {
        UIActivityIndicatorView *_activity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
  //  self.tableView.contentInset = UIEdgeInsetsMake(80, 0, self.view.frame.size.height, self.view.frame.size.width);
    
    // clear noused rows
//    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [repository count:FavoriteType_Seller];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  70.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SellerInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SellerInfoCell"];
    if (cell == nil)
        cell = [[SellerInfoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SellerInfoCell"];
    
    // Configure the cell...
    FavoriteRepository *repository = [FavoriteRepository sharedClient];
    [cell setModel:[repository itemAtIndex:indexPath.row type:FavoriteType_Seller]];

    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    [buttons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    [cell setRightUtilityButtons:buttons WithButtonWidth:50];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SellerInfoViewController"];
    FavoriteRepository *repository = [FavoriteRepository sharedClient];
    SellerInfoModel *info = [repository itemAtIndex:indexPath.row type:FavoriteType_Seller];
    
    if ([controller respondsToSelector:@selector(setSellerId:)]) {
        [controller setValue:info.seller_id forKey:@"sellerId"];
    }
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    // delete notification from notifyCenter
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    FavoriteRepository *repository = [FavoriteRepository sharedClient];
    [repository removeItem:path.row type:FavoriteType_Seller];
    [self.tableView reloadData];
}

@end
