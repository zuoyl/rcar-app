//
//  OrderDetailBookViewController.m
//  CarUser
//
//  Created by jenson.zuo on 10/8/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "MyOrderDetailBookViewController.h"
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

@interface MyOrderDetailBookViewController ()
@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) SSTextView *feedbackTextView;
@end

@implementation MyOrderDetailBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    else if (section == SectionDetail) {
        NSArray *services = [self.order.detail objectForKey:@"services"];
        if (services != nil)
            return services.count;
        else
            return 0;
    }
    else if (section == SectionReply)
        return 3;
    else return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionInfo) return 35.f;
    else if (indexPath.section == SectionDetail) return 35.f;
    else if (indexPath.section == SectionReply) {
        if (indexPath.row == 2) return 60.f;
        else return 35.f;
    }
    else return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == SectionReply) return 40.f;
    else return 0.5f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"订单信息", @"服务项目", @"商家回复"];
    return [titles objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *loadView = nil;
    if (section == SectionReply) {
        loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.f)];
        if (self.finishBtn == nil) {
            self.finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
            [self.finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.finishBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
        }
        
        if (section == SectionReply && [self.order.status isEqualToString:@"selected"]) {
            [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
            [self.finishBtn addTarget:self action:@selector(finishBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [self.finishBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.finishBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        [loadView addSubview:self.finishBtn];

    }
    return loadView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MyOrderDetailBookItemCell";
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
                NSArray *services = [self.order.detail objectForKey:@"services"];
                
                if (services.count == 1 )
                    cell.detailTextLabel.text = [[services objectAtIndex:0] objectForKey:@"service_type"];
                else if (services.count > 1)
                    cell.detailTextLabel.text = @"预订多项服务";
                else {
                    cell.detailTextLabel.text = @"错误订单";
                }
                
                
                
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"用户";
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                if (self.order.user_name != nil && ![self.order.user_name isEqualToString:@""])
                    cell.detailTextLabel.text = self.order.user_name;
                else
                    cell.detailTextLabel.text = self.order.user_id;
                
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"预约时间";
                cell.detailTextLabel.text = self.order.date_time;
            } else if (indexPath.row == 3) {
                cell.textLabel.text = @"订单状态";
                if ([self.order.status isEqualToString:@"new"])
                    cell.detailTextLabel.text = @"未受理";
                else if ([self.order.status isEqualToString:@"completed"])
                    cell.detailTextLabel.text = @"处理完了";
                else if ([self.order.status isEqualToString:@"canceled"])
                    cell.detailTextLabel.text = @"已撤销";
                else if ([self.order.status isEqualToString:@"selected"])
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
            
        case SectionReply: {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"工时";
                cell.detailTextLabel.text = [[self.order.reply objectForKey:@"time" ] stringByAppendingString:@"小时"];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"费用";
                cell.detailTextLabel.text = [[self.order.reply objectForKey:@"cost"]stringByAppendingString:@"元"];
                
            }else if (indexPath.row == 2) {
                if (self.feedbackTextView == nil)
                    self.feedbackTextView = [[SSTextView alloc]initWithFrame:cell.contentView.frame];
                
                [self.feedbackTextView setContentInset:UIEdgeInsetsMake(2, 10, 2, 10)];
                self.feedbackTextView.font = [UIFont systemFontOfSize:14.f];
                NSString *feedback = [self.order.reply objectForKey:@"feedback"];
                if (feedback == nil || [feedback isEqualToString:@""])
                    self.feedbackTextView.placeholder = @"感谢您的预约";
                else
                    self.feedbackTextView.text = feedback;
                [cell.contentView addSubview:self.feedbackTextView];
            } else {}
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionInfo && indexPath.row == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"User" bundle:nil];
        UserInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
        controller.user_id = self.order.user_id;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }

}


#pragma mark - UIButton selector
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
        [params setObject:@"非常抱歉取消您的订单" forKey:@"reply"];
    
    [self setOrderStatus:@"completed" info:params];
    // update local order status
    SellerModel *seller = [SellerModel sharedClient];
    [seller updateOrderStatus:self.order.order_id status:@"cancel"];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
