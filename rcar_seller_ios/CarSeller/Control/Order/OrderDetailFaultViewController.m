//
//  OrderDetailFaultViewController.m
//  CarUser
//
//  Created by jenson.zuo on 10/8/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "OrderDetailFaultViewController.h"

#import "SellerServiceModel.h"
#import "SellerInfoViewController.h"
#import "SSTextView.h"
#import "PhotoAlbumView.h"
#import "MxTextField.h"
#import "UserInfoViewController.h"

enum {
    SectionInfo = 0,
    SectionDetail,
    SectionImage,
    SectionReply,
    SectionMax,
};

@interface OrderDetailFaultViewController ()<MxTextFieldDelegate>
@property (nonatomic, strong) SSTextView *feedbackTextView;
@property (nonatomic, strong) MxTextField *costTextField;
@property (nonatomic, strong) MxTextField *timeTextField;
@property (nonatomic, strong) PhotoAlbumView *photoAlbumView;

@end

@implementation OrderDetailFaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FaultItemCell"];
//    [self loadOrderDetail];
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
    if (section == SectionInfo) return 6;
    else if (section == SectionDetail) {
        NSDictionary *items = [self.order.detail objectForKey:@"items"];
        return items.count;
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
    if (section == SectionReply && [self.order.status isEqualToString:@"new"]) {
        loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.f)];
        
        UIButton *agreeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width/2 -1, 40)];
            [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
            [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            agreeBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
            [agreeBtn addTarget:self action:@selector(agreeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [loadView addSubview:agreeBtn];
        
        UIButton *ignoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width/2 +1, 0, self.tableView.frame.size.width/2, 40)];
        [ignoreBtn setTitle:@"忽略" forState:UIControlStateNormal];
        [ignoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ignoreBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
        [ignoreBtn addTarget:self action:@selector(ignoreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [loadView addSubview:ignoreBtn];
        
    } else if (section == SectionReply && [self.order.status isEqualToString:@"agree"]) {
        loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.f)];
        
        UIButton *agreeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
        [agreeBtn setTitle:@"撤销已发出的订单" forState:UIControlStateNormal];
        [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        agreeBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
        [agreeBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [loadView addSubview:agreeBtn];
        
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
    
    CGFloat cellHeight = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
    // Configure the cell...
    switch (indexPath.section) {
        case SectionInfo:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"服务项目";
                cell.detailTextLabel.text = @"故障维修";
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"用户";
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                if (self.order.user_name == nil || [self.order.user_name isEqualToString:@""])
                    cell.detailTextLabel.text = self.order.user_id;
                else
                    cell.detailTextLabel.text = self.order.user_name;
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
            }  else if (indexPath.row == 5){
                cell.textLabel.text = @"车牌号";
                cell.detailTextLabel.text = self.order.platenumber;
            } else {
                cell.textLabel.text = @"是否出现场维修";
                NSString *touser = [self.order.detail objectForKey:@"touser"];
                if ([touser isEqualToString:@"yes"])
                    cell.detailTextLabel.text = @"出现场";
                else
                    cell.detailTextLabel.text = @"不出现场";
                
            }
            break;
            
        case SectionDetail:{
            NSArray *items = [self.order.detail objectForKey:@"items"];
            NSString *descs = [items objectAtIndex:indexPath.row];
            NSArray *descArray = [descs componentsSeparatedByString:@"-"];
        
            if (descArray.count == 1) {
                cell.textLabel.text = [descArray objectAtIndex:0];
                cell.detailTextLabel.text = @"用户未填写";
            } else if (descArray.count == 3) {
                cell.textLabel.text = [descArray[0] stringByAppendingString:descArray[1]];
                cell.detailTextLabel.text = descArray[2];
            } else {
                cell.textLabel.text = descs;
            }
            break;
        }
            
        case SectionImage: {
                NSArray *images = [self.order.detail objectForKey:@"images"];
                if (images == nil || images.count == 0) {
                    cell.textLabel.text = @"用户未提供车辆故障图片";
                } else {
                    if (self.photoAlbumView == nil) {
                        self.photoAlbumView = [PhotoAlbumView initWithViewController:self frame:cell.contentView.frame mode:PhotoAlbumMode_View];
                    }
                    self.photoAlbumView.maxOfImage = 5;
                    [self.photoAlbumView loadImages:images];
                    [cell.contentView addSubview:self.photoAlbumView];
                }
            }
            break;
            
        case SectionReply:
            if (indexPath.row == 0) {
                if (self.timeTextField == nil) {
                    self.timeTextField = [[MxTextField alloc]initWithFrame:CGRectMake(80, 0, self.view.frame.size.width - 125, cellHeight)];
                    self.timeTextField.font = [UIFont systemFontOfSize:14.f];
                    self.timeTextField.contentMode = UIViewContentModeCenter;
                    self.timeTextField.placeholder = @"请输入工时";
                    self.timeTextField.keyboardType = UIKeyboardTypeNumberPad;
                    self.timeTextField.returnKeyType = UIReturnKeyDone;
                    self.timeTextField.contentMode = UIControlContentVerticalAlignmentCenter;
                    self.timeTextField.textAlignment = NSTextAlignmentRight;
                    self.timeTextField.mxDelegate = self;
                    [self.timeTextField addRule:[Rules checkIfNumericWithFailureString:@"只能填写数字" forTextField:self.timeTextField]];
                }
                [cell.contentView addSubview:self.timeTextField];
                self.timeTextField.text = self.order.time;
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, 0, 30, cellHeight)];
                label.contentMode = UIControlContentVerticalAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14.f];
                label.text = @"小时";
                label.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:label];
                
                cell.textLabel.text = @"工时";
                
            } else if (indexPath.row == 1) {
                if (self.costTextField == nil) {
                    self.costTextField = [[MxTextField alloc]initWithFrame:CGRectMake(80, 0, self.view.frame.size.width - 125, cellHeight)];
                    cell.textLabel.text = @"费用";
                    self.costTextField.font = [UIFont systemFontOfSize:14.f];
                    self.costTextField.placeholder = @"请输入费用";
                    self.costTextField.keyboardType = UIKeyboardTypeNumberPad;
                    self.costTextField.returnKeyType = UIReturnKeyDone;
                    self.costTextField.contentMode = UIControlContentVerticalAlignmentCenter;
                    self.costTextField.textAlignment = NSTextAlignmentRight;
                    self.costTextField.mxDelegate = self;
                    [self.costTextField addRule:[Rules checkIfNumericWithFailureString:@"只能填写数字" forTextField:self.costTextField]];
                }
                [cell.contentView addSubview:self.costTextField];
                self.costTextField.text = self.order.cost;
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, 0, 30, cellHeight)];
                label.font = [UIFont systemFontOfSize:14.f];
                label.text = @"元";
                label.contentMode = UIControlContentVerticalAlignmentCenter;
                [cell.contentView addSubview:label];
                
            }else if (indexPath.row == 2) {
                if (self.feedbackTextView == nil)
                    self.feedbackTextView = [[SSTextView alloc]initWithFrame:cell.contentView.frame];
                
                [self.feedbackTextView setContentInset:UIEdgeInsetsMake(2, 10, 2, 10)];
                self.feedbackTextView.font = [UIFont systemFontOfSize:14.f];
                self.feedbackTextView.placeholder = @"感谢您的预约";
                self.feedbackTextView.keyboardType = UIKeyboardTypeASCIICapable;
                self.feedbackTextView.returnKeyType = UIReturnKeyDone;
                self.feedbackTextView.text = self.order.feedback;
                
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

- (void)agreeBtnClicked:(id)sender {
    if (self.costTextField.isValid == NO || self.timeTextField.isValid == NO) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请正确填写订单信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
    
    if ([self.costTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写费用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
    if ([self.timeTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写工时" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:self.costTextField.text forKey:@"cost"];
    [params setObject:self.timeTextField.text forKey:@"time"];
    
    if (![self.feedbackTextView.text isEqualToString:@""])
        [params setObject:self.feedbackTextView.text forKey:@"reply"];
    else
        [params setObject:@"感谢您的预约" forKey:@"reply"];
    
    [self setOrderStatus:@"agree" info:params];
    
    SellerModel *seller = [SellerModel sharedClient];
    [seller.orders addObject:self.order];
    [self.allOrders removeObject:self.order];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)ignoreBtnClicked:(id)sender {
    [self setOrderStatus:@"ignore" info:nil];
    // remove order from local
    [self.allOrders removeObject:self.order];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelBtnClicked:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (![self.feedbackTextView.text isEqualToString:@""])
        [params setObject:self.feedbackTextView.text forKey:@"reply"];
    else
        [params setObject:@"非常抱歉撤销您的订单" forKey:@"reply"];
    
    [self setOrderStatus:@"canceled" info:params];
}

@end
