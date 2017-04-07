//
//  CommodityDetailViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerCommodityDetailViewController.h"
#import "FavoriteRepository.h"
#import "ImagePageView.h"
#import "CommentModel.h"

@interface SellerCommodityDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation SellerCommodityDetailViewController

@synthesize tableView;
@synthesize model;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商品详细";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    // if the commodity already exist in repository, don't add favorite button
    FavoriteRepository *repository = [FavoriteRepository sharedClient];
    NSInteger total = [repository count:FavoriteType_Commodity];
    NSInteger index = 0;
    for (; index < total; index++) {
        SellerCommodityModel *commodity = [repository itemAtIndex:index type:FavoriteType_Commodity];
        if ([commodity.seller_id isEqualToString:self.model.seller_id] && [commodity.name isEqualToString:self.model.name])
            break;
    }
    if (index == total) { // not found
        // add favorite button
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(addCommodityToFavorite:)];
        [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    // add table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCommodityToFavorite:(id)sender {
    FavoriteRepository *repository = [FavoriteRepository sharedClient];
    [repository addItem:self.model type:FavoriteType_Commodity];
}

typedef enum {
    CommodityDetailSectionInfo = 0,
    CommodityDetailSectionComment,
    CommodityDetailSectionMax
} CommodityDetailSection;

typedef enum {
    CommodityDetailIndexInfoImage = 0,
    CommodityDetailIndexInfoName,
    CommodityDetailIndexInfoPrice,
    CommodityDetailIndexInfoNumber,
    CommodityDetailIndexInfoMax
} CommodityDetailIndex;

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"commodity_show_comments"]) {
        UIViewController *controler = segue.destinationViewController;
        [controler setValue:self.model forKey:@"model"];
        controler.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return CommodityDetailSectionMax;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == CommodityDetailSectionComment) return 20.f;
    else return 0.5f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == CommodityDetailSectionInfo)
        return CommodityDetailIndexInfoMax;
    else if (section == CommodityDetailSectionComment) {
        if (self.model.comments.count > 0) return 2;
        else return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == CommodityDetailSectionInfo)  {
        if (indexPath.row == CommodityDetailIndexInfoImage) return 120;
        else return 30;
    }
    else return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == CommodityDetailSectionComment) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        // for header view
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 60, 20)];
        titleLabel.font = [UIFont systemFontOfSize:15.f];
        titleLabel.text = @"用户评价";
        [headerView addSubview:titleLabel];
        
        // for totlal view
        UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 0, 50, 20)];
        totalLabel.font = [UIFont systemFontOfSize:15.f];
        totalLabel.text = [NSString stringWithFormat:@"%lu件", self.model.comments.count];
        [headerView addSubview:totalLabel];
        return headerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == CommodityDetailSectionInfo) {
        static NSString *reuseIdentifier = @"TableViewCellInfo";
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.row == CommodityDetailIndexInfoImage) {
            ImagePageView *imageView = [[ImagePageView alloc]initWithFrame:cell.frame];
            [cell addSubview:imageView];
            [imageView setImages:self.model.images];
            return cell;
        }
        else if (indexPath.row == CommodityDetailIndexInfoName) {
            cell.textLabel.text = @"名称";
            cell.detailTextLabel.text = self.model.name;
        }
        else if (indexPath.row == CommodityDetailIndexInfoPrice) {
            cell.textLabel.text = @"价格";
            cell.detailTextLabel.text = self.model.price;
        } else if (indexPath.row == CommodityDetailIndexInfoNumber) {
            cell.textLabel.text = @"库存";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", self.model.left];
        } else {}
        return cell;
        
    } else if (indexPath.section == CommodityDetailSectionComment) {
        static NSString *reuseIdentifier = @"TableViewCellComment";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        if (self.model.comments.count == 0) {
            cell.textLabel.text = @"该商品没有评价";
            cell.textLabel.font = [UIFont systemFontOfSize:12.f];
        } else {
            if (indexPath.row == 0) {
                CommentModel *comment = [self.model.comments objectAtIndex:0];
                cell.textLabel.text = comment.user;
                cell.detailTextLabel.text = comment.desc;
            } else {
                cell.textLabel.text = @"点击查看更多评价";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else {
        
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == CommodityDetailSectionComment) {
        if (self.model.comments.count && indexPath.row == 1)
            [self performSegueWithIdentifier:@"commodity_show_comments" sender:self];
    }
}


@end
