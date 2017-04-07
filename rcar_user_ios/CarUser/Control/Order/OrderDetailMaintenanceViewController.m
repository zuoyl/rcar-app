//
//  OrderDetailMaintenanceViewController.m
//  CarUser
//
//  Created by jenson.zuo on 10/8/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "OrderDetailMaintenanceViewController.h"
#import "SellerServiceModel.h"
#import "SellerInfoViewController.h"

enum {
    SectionInfo = 0,
    SectionDetail,
    SectionMax,
};

@interface OrderDetailMaintenanceViewController ()

@end

@implementation OrderDetailMaintenanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"show_order_waiting"]) {
         [segue.destinationViewController setValue:self.order.order_id forKey:@"order_id"];
         [segue.destinationViewController setValue:@"maintenance" forKey:@"order_type"];
         [segue.destinationViewController setValue:self forKey:@"rootController"];
     }
 }

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return SectionMax;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == SectionInfo) return 7;
    else if (section == SectionDetail) {
        NSString *type = [self.order.detail objectForKey:@"type"];
        if ([type isEqualToString:@"unknown"])
            return 1;
        else {
            NSArray *mileageItems = [self.order.detail objectForKey:@"mileage_items"];
            NSArray *userItems = [self.order.detail objectForKey:@"user_items"];
            return mileageItems.count + userItems.count;
        }
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
    NSArray *titles = @[@"订单信息", @"保养项目"];
    return [titles objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *loadView = nil;
    if (section == (SectionMax - 1)) {
        if (![self.order.status isEqualToString:@"canceled"]) {
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
                cell.detailTextLabel.text = @"车辆保养";
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"商家名称";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"已推送%ld商家", self.order.target_seller.count];
                if ([self.order.status isEqualToString:@"new"])
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"预约时间";
                cell.detailTextLabel.text = self.order.date_time;
            } else if (indexPath.row == 3) {
                cell.textLabel.text = @"订单状态";
                
                if ([self.order.status isEqualToString:kOrderStatusNew]) {
                    cell.detailTextLabel.text = @"推送中";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                } else if ([self.order.status isEqualToString:kOrderStatusConfirmed]) {
                    cell.detailTextLabel.text = @"确定";
                } else if ([self.order.status isEqualToString:kOrderStatusCompleted])
                    cell.detailTextLabel.text = @"处理完了";
                else if ([self.order.status isEqualToString:kOrderStatusCanceled])
                    cell.detailTextLabel.text = @"已撤销";
                else
                    cell.detailTextLabel.text = @"未知状态";
            } else if (indexPath.row == 4){
                cell.textLabel.text = @"车牌号";
                cell.detailTextLabel.text = self.order.platenumber;
            } else if (indexPath.row == 5) {
                cell.textLabel.text = @"保养类型";
                if ([[self.order.detail objectForKey:@"type"] isEqualToString:@"unknown"])
                    cell.detailTextLabel.text = @"我不知道什么项目,到店检查";
                else
                    cell.detailTextLabel.text = @"按车辆里程数保养";
            } else {
                cell.textLabel.text = @"保养里程数";
                cell.detailTextLabel.text = [self.order.detail objectForKey:@"mileage"];
            }
            break;
            
        case SectionDetail:
            // get all items and seller's reply
            if ([self.order.status isEqualToString:kOrderStatusConfirmed] && self.order.seller != nil) {
                NSArray *mileageItems = [self.order.seller objectForKey:@"mileage_items"];
                NSArray *userItems = [self.order.seller objectForKey:@"user_items"];
                NSInteger index = indexPath.row;
                if (index < mileageItems.count) {
                    cell.textLabel.text = [mileageItems[index] objectForKey:@"item"];
                    cell.detailTextLabel.text = [mileageItems[index] objectForKey:@"price"];
                }
                else {
                    index -= mileageItems.count;
                    cell.textLabel.text = [userItems[index] objectForKey:@"item"];
                    cell.detailTextLabel.text = [userItems[index] objectForKey:@"price"];
                }
            } else {
                NSInteger index = indexPath.row;
                NSArray *mileageItems = [self.order.detail objectForKey:@"mileage_items"];
                NSArray *userItems = [self.order.detail objectForKey:@"user_items"];
                if (index < mileageItems.count)
                    cell.textLabel.text = [mileageItems objectAtIndex:index];
                else {
                    index -= mileageItems.count;
                    cell.textLabel.text = [userItems objectAtIndex:index];
                }
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionInfo && (indexPath.row == 1 || indexPath.row == 3)) {
        if ([self.order.status isEqualToString:@"new"])
            [self performSegueWithIdentifier:@"show_order_waiting" sender:self];
    }

}

@end
