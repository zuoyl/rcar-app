//
//  OrderDetailBookViewController.m
//  CarUser
//
//  Created by jenson.zuo on 10/8/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "OrderDetailBookViewController.h"
#import "SellerServiceModel.h"
#import "SellerInfoViewController.h"

enum {
    SectionInfo = 0,
    SectionDetail,
    SectionMax,
};

@interface OrderDetailBookViewController ()

@end

@implementation OrderDetailBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return SectionMax;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == SectionInfo) return 5;
    else if (section == SectionDetail &&[self.order.order_type isEqualToString:@"books"]) {
        NSArray *services = [self.order.detail objectForKey:@"services"];
        if (services != nil)
            return services.count;
        else return 0;
    }
    else return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionInfo) return 35.f;
    else if (indexPath.section == SectionDetail) return 35.f;
    // else if (indexPath.section == SectionReply) return 60.f;
    else return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == SectionDetail) return 40.f;
    else return 0.5f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"订单信息", @"服务详细"];
    return [titles objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *loadView = nil;
    if (section == SectionDetail && ![self.order.status isEqualToString:@"canceled"]) {
        loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.f)];
        UIButton *button = [[UIButton alloc]initWithFrame:loadView.frame];
        [button setTitle:@"撤销订单" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        button.backgroundColor = [UIColor colorWithHex:@"2480ff"];
        [button addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [loadView addSubview:button];
    } else if (section == SectionDetail && [self.order.status isEqualToString:@"canceled"]) {
        loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.f)];
        UIButton *button = [[UIButton alloc]initWithFrame:loadView.frame];
        [button setTitle:@"删除订单" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        button.backgroundColor = [UIColor colorWithHex:@"2480ff"];
        [button addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [loadView addSubview:button];
    }
    
    return loadView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"itemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    // Configure the cell...
    switch (indexPath.section) {
        case SectionInfo:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"服务项目";
                if (self.order.order_service_type != nil && ![self.order.order_service_type isEqualToString:@""]) {
                    cell.detailTextLabel.text = self.order.order_service_type;
                } else if (self.order.detail != nil && self.order.detail.count > 0) {
                    NSArray *services = [self.order.detail objectForKey:@"services"];
                    if (services.count == 1) {
                        NSDictionary *service = [services objectAtIndex:0];
                        cell.detailTextLabel.text = [service objectForKey:@"service_type"];
                    } else {
                        cell.detailTextLabel.text = @"预订多项服务";
                    }
                }
            } else if (indexPath.row == 1) {
                NSDictionary *seller = [self.order.target_seller objectAtIndex:0];
                cell.textLabel.text = @"商家名称";
                cell.detailTextLabel.text = [seller objectForKey:@"seller_name"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"预约时间";
                cell.detailTextLabel.text = self.order.date_time;
            } else if (indexPath.row == 3) {
                cell.textLabel.text = @"订单状态";
                if ([self.order.status isEqualToString:@"new"])
                    cell.detailTextLabel.text = @"商家处理中";
                else if ([self.order.status isEqualToString:@"completed"])
                    cell.detailTextLabel.text = @"处理完了";
                else if ([self.order.status isEqualToString:@"canceled"])
                    cell.detailTextLabel.text = @"已撤销";
                else
                    cell.detailTextLabel.text = @"处理中";
            } else {
                cell.textLabel.text = @"车牌号";
                cell.detailTextLabel.text = self.order.platenumber;
            }
            break;
            
        case SectionDetail: {
            NSArray *services = [self.order.detail objectForKey:@"services"];
            NSDictionary *service = [services objectAtIndex:indexPath.row];
            cell.textLabel.text = [service objectForKey:@"title"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@", [service objectForKey:@"price"]];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionInfo && indexPath.row == 1) {
        NSDictionary *sellers = [self.order.target_seller objectAtIndex:0];
        NSString *seller_id = [sellers objectForKey:@"seller_id"];
        
        if (seller_id != nil && ![seller_id isEqualToString:@""]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
            SellerInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SellerInfoViewController"];
            controller.sellerId = seller_id;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
    }
}
@end
