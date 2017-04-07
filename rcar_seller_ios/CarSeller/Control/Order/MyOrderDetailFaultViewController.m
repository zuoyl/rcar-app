//
//  OrderDetailFaultViewController.m
//  CarUser
//
//  Created by jenson.zuo on 10/8/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "MyOrderDetailFaultViewController.h"

#import "SellerServiceModel.h"
#import "SellerInfoViewController.h"
#import "SSTextView.h"
#import "PhotoAlbumView.h"
#import "UserInfoViewController.h"

enum {
    SectionInfo = 0,
    SectionDetail,
    SectionImage,
    SectionReply,
    SectionMax,
};

@interface MyOrderDetailFaultViewController ()
//@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) SSTextView *feedbackTextView;
@property (nonatomic, strong) PhotoAlbumView *photoAlbumView;

@end

@implementation MyOrderDetailFaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FaultItemCell"];
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
    if (section == SectionInfo) return 5;
    else if (section == SectionDetail) {
        NSArray *items = [self.order.detail objectForKey:@"items"];
        NSString *touser = [self.order.detail objectForKey:@"touser"];
        if ([touser isEqualToString:@"yes"])
            return items.count + 2;
        else
            return items.count + 1;
    } else if (section == SectionImage) return 1;
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
    } else if (indexPath.section == SectionImage)  {
        if (self.order.images == nil || self.order.images.count == 0)  return 35.f;
        else return 90.f;
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
    NSArray *titles = @[@"订单信息", @"故障项目", @"故障图片", @"商家回复"];
    return [titles objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *loadView = nil;
    if (section == SectionReply) {
        loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.f)];
        UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
        [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        finishBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
        [finishBtn addTarget:self action:@selector(finishBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [loadView addSubview:finishBtn];
        
        if ([self.order.status isEqualToString:@"selected"]) {
            [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        } else {
            [finishBtn setTitle:@"撤销" forState:UIControlStateNormal];
        }
    }
    
    return loadView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"FaultItemCell";
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
                cell.detailTextLabel.text = @"故障维修";
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
                if ([self.order.status isEqualToString:@"new"]) {
                    cell.detailTextLabel.text = @"未受理";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                } else if ([self.order.status isEqualToString:@"completed"])
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
            
        case SectionDetail:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"是否出现场维修";
                NSString *touser = [self.order.detail objectForKey:@"touser"];
                if ([touser isEqualToString:@"yes"])
                    cell.detailTextLabel.text = @"出现场";
                else
                    cell.detailTextLabel.text = @"不出现场";
                
            } else {
                NSArray *items = [self.order.detail objectForKey:@"items"];
                NSString *touser = [self.order.detail objectForKey:@"touser"];
                if ([touser isEqualToString:@"yes"]) {
                    if (indexPath.row == 1) {
                        cell.textLabel.text = @"故障位置";
                        cell.detailTextLabel.text = [self.order.detail objectForKey:@"position"];
                        break;
                    } else {
                        NSString *descs = [items objectAtIndex:(indexPath.row - 2)];
                        NSArray *descArray = [descs componentsSeparatedByString:@"-"];
                        cell.textLabel.text = [descArray[0] stringByAppendingString:descArray[1]];
                        cell.detailTextLabel.text = descArray[2];
                    }
                } else {
                    NSString *descs = [items objectAtIndex:(indexPath.row - 1)];
                    NSArray *descArray = [descs componentsSeparatedByString:@"-"];
                    cell.textLabel.text = [descArray[0] stringByAppendingString:descArray[1]];
                    cell.detailTextLabel.text = descArray[2];
                }
            }
            break;
            
        case SectionImage:
            if (self.order.images == nil || self.order.images.count == 0) {
                cell.textLabel.text = @"用户未提供车辆故障图片";
            } else {
                if (self.photoAlbumView == nil) {
                    self.photoAlbumView = [PhotoAlbumView initWithViewController:self frame:cell.contentView.frame mode:PhotoAlbumMode_View];
                }
                self.photoAlbumView.maxOfImage = 5;
                [self.photoAlbumView loadImages:self.order.images];
                [cell.contentView addSubview:self.photoAlbumView];
            }
            break;
            
        case SectionReply:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"工时";
                cell.detailTextLabel.text = [[self.order.reply objectForKey:@"time" ] stringByAppendingString:@"小时"];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"费用";
                cell.detailTextLabel.text = [[self.order.reply objectForKey:@"cost"] stringByAppendingString:@"元"];
                
            }else if (indexPath.row == 2) {
                if (self.feedbackTextView == nil)
                    self.feedbackTextView = [[SSTextView alloc]initWithFrame:cell.contentView.frame];
                
                [self.feedbackTextView setContentInset:UIEdgeInsetsMake(2, 10, 2, 10)];
                self.feedbackTextView.font = [UIFont systemFontOfSize:14.f];
                self.order.feedback = [self.order.reply objectForKey:@"reply"];
                if (self.order.feedback != nil && [self.order.feedback isEqualToString:@""])
                    self.feedbackTextView.text = self.order.feedback;
                else
                    self.feedbackTextView.placeholder = @"请填写用户反馈信息";
                [cell.contentView addSubview:self.feedbackTextView];
            } else {}

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



- (void)finishBtnClicked:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (![self.feedbackTextView.text isEqualToString:@""])
        [params setObject:self.feedbackTextView.text forKey:@"reply"];
    else
        [params setObject:@"您的订单已完成" forKey:@"reply"];
  
    SellerModel *seller = [SellerModel sharedClient];
    if ( [self.order.status isEqualToString:@"selected"]) {
        [self setOrderStatus:@"completed" info:params];
        // update local order status
        [seller updateOrderStatus:self.order.order_id status:@"completed"];
    }
    else {
        [self setOrderStatus:@"canceled" info:params];
        [seller updateOrderStatus:self.order.order_id status:@"canceled"];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
