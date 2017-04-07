//
//  OrderDetailMaintenanceViewController.m
//  CarUser
//
//  Created by jenson.zuo on 10/8/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "MyOrderDetailMaintenanceViewController.h"
#import "SellerServiceModel.h"
#import "SellerInfoViewController.h"
#import "SSTextView.h"
#import "UserInfoViewController.h"

enum {
    SectionInfo = 0,
    SectionDetail,
    SectionReply,
    SectionMax,
};

@interface MyOrderDetailMaintenanceViewController ()
@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) SSTextView *feedbackTextView;
@property (nonatomic, strong) NSString *maintenaneType;
@property (nonatomic, strong) NSMutableDictionary *allItems;
@end

@implementation MyOrderDetailMaintenanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *milageItems = [self.order.reply objectForKey:@"mileage_items"];
    NSDictionary *userItems = [self.order.reply objectForKey:@"user_items"];
    self.maintenaneType = [self.order.reply objectForKey:@"type"];
    
    self.allItems = [[NSMutableDictionary alloc]init];
    [self.allItems addEntriesFromDictionary:milageItems];
    [self.allItems addEntriesFromDictionary:userItems];
    
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
 }

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return SectionMax;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == SectionInfo) return  6;
    else if (section == SectionDetail) {
        if (self.allItems.count == 0)
            return 1;
        else
            return self.allItems.allKeys.count;
        
    } else if (section == SectionReply)
        return 3;
    else return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionInfo) return 35.f;
    else if (indexPath.section == SectionDetail) return 35.f;
    else if (indexPath.section == SectionReply) {
        if (indexPath.row == 2) return 60.f;
        else return 35.f;
    } else return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == SectionReply) return 40.f;
    else return 0.5f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"订单信息", @"保养项目", @"商家回复"];
    return [titles objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *loadView = nil;
    if (section == SectionReply && [self.order.status isEqualToString:@"selected"]) {
        loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.f)];
        if (self.finishBtn == nil) {
            self.finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
            [self.finishBtn setTitle:@"完成订单" forState:UIControlStateNormal];
            [self.finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.finishBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
            [self.finishBtn addTarget:self action:@selector(finishBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        [loadView addSubview:self.finishBtn];
    } else {
        loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.f)];
        if (self.finishBtn == nil) {
            self.finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
            [self.finishBtn setTitle:@"撤销订单" forState:UIControlStateNormal];
            [self.finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.finishBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
            [self.finishBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        [loadView addSubview:self.finishBtn];
        
    }
    
    return loadView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MyOrderDetailMainteancneItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    } else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
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
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                cell.textLabel.text = @"用户";
                if (self.order.user_name != nil && ![self.order.user_name isEqualToString:@""])
                    cell.detailTextLabel.text = self.order.user_name;
                else
                    cell.detailTextLabel.text = self.order.user_id;
             } else if (indexPath.row == 2) {
                cell.textLabel.text = @"预约时间";
                cell.detailTextLabel.text = self.order.date_time;
            } else if (indexPath.row == 3) {
                cell.textLabel.text = @"订单状态";
                if ([self.order.status isEqualToString:@"new"]) {
                    cell.detailTextLabel.text = @"未受理";
                } else if ([self.order.status isEqualToString:@"completed"])
                    cell.detailTextLabel.text = @"处理完了";
                else if ([self.order.status isEqualToString:@"canceled"])
                    cell.detailTextLabel.text = @"已撤销";
                else
                    cell.detailTextLabel.text = @"处理中";
            } else if (indexPath.row == 4){
                cell.textLabel.text = @"车牌号";
                cell.detailTextLabel.text = self.order.platenumber;
            } else if (indexPath.row == 5) {
                cell.textLabel.text = @"保养类型";
                if ([self.maintenaneType isEqualToString:@"unkown"])
                    cell.detailTextLabel.text = @"我不知道什么项目,到店检查";
                else
                    cell.detailTextLabel.text = @"按车辆里程数保养";
            } else {
                cell.textLabel.text = @"车辆行驶里程数";
                NSString *mileage = [self.order.detail objectForKey:@"mileage"];
                if (mileage == nil || [mileage isEqualToString:@""])
                    cell.detailTextLabel.text = @"未知";
                else
                    cell.detailTextLabel.text = [mileage stringByAppendingString:@"公里"];
            }
            break;
            
        case SectionDetail:
            if (self.allItems.allKeys.count == 0) {
                cell.textLabel.text = @"没有保养项目";
            } else {
                NSString *item = [self.allItems.allKeys objectAtIndex:indexPath.row];
                cell.textLabel.text = item;
                cell.detailTextLabel.text = [[self.allItems objectForKey:item] stringByAppendingString:@"元"];
            }
            break;
        case SectionReply:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"工时";
                NSString *time = [self.order.reply objectForKey:@"time"];
                cell.detailTextLabel.text = [time stringByAppendingString:@"小时"];
            } else if (indexPath.row == 1) {
                NSString *cost = [self.order.reply objectForKey:@"cost"];
                cell.textLabel.text = @"费用";
                cell.detailTextLabel.text = [cost stringByAppendingString:@"元"];
                
            }else if (indexPath.row == 2) {
                if (self.feedbackTextView == nil)
                    self.feedbackTextView = [[SSTextView alloc]initWithFrame:cell.contentView.frame];
                
                [self.feedbackTextView setContentInset:UIEdgeInsetsMake(2, 10, 2, 10)];
                self.feedbackTextView.font = [UIFont systemFontOfSize:14.f];
                NSString *feedback = [self.order.reply objectForKey:@"feedback"];
                if (feedback == nil || [feedback isEqualToString:@""])
                    self.feedbackTextView.placeholder = @"该商家没有留言";
                else
                    self.feedbackTextView.text = feedback;
                [cell.contentView addSubview:self.feedbackTextView];
            } else {}
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"User" bundle:nil];
        UserInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
        controller.user_id = self.order.user_id;
        controller.editMode = YES;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
}



- (void)finishBtnClicked:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (![self.feedbackTextView.text isEqualToString:@""])
        [params setObject:self.feedbackTextView.text forKey:@"reply"];
    else
        [params setObject:@"您的订单已完成" forKey:@"reply"];
  
    [self setOrderStatus:@"completed" info:params];
    // update local order status
    SellerModel *seller = [SellerModel sharedClient];
    [seller updateOrderStatus:self.order.order_id status:@"completed"];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)cancelBtnClicked:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (![self.feedbackTextView.text isEqualToString:@""])
        [params setObject:self.feedbackTextView.text forKey:@"reply"];
    else
        [params setObject:@"非常抱歉的通知您：您的订单已撤销" forKey:@"reply"];
    
    [self setOrderStatus:@"canceled" info:params];
    // update local order status
    SellerModel *seller = [SellerModel sharedClient];
    [seller updateOrderStatus:self.order.order_id status:@"canceled"];
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
