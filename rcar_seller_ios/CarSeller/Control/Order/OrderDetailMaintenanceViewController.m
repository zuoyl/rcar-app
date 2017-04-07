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
#import "SSTextView.h"
#import "MxLabelsMatrix.h"
#import "UserInfoViewController.h"

#import "MxTextField.h"
#import "Validator.h"

enum {
    SectionInfo = 0,
    SectionDetail,
    SectionReply,
    SectionMax,
};

@interface OrderDetailMaintenanceViewController () <MxTextFieldDelegate>
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) UIButton *ignoreBtn;
@property (nonatomic, strong) SSTextView *feedbackTextView;
@property (nonatomic, strong) MxTextField *costTextField;
@property (nonatomic, strong) MxTextField *timeTextField;
@property (nonatomic, strong) NSMutableDictionary *milageItems;
@property (nonatomic, strong) NSMutableDictionary *userItems;
@property (nonatomic, strong) NSString *maintenaneType;
@property (nonatomic, strong) NSMutableArray *allItems;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;


@end

@implementation OrderDetailMaintenanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.milageItems = [[NSMutableDictionary alloc]init];
    self.userItems = [[NSMutableDictionary alloc]init];
    self.maintenaneType = @"mileage";
    
    NSArray *items = [self.order.detail objectForKey:@"mileage_items"];
    for (NSString *itemTitle in items)
        [self.milageItems setValue:@"-" forKey:itemTitle];
    
    items = [self.order.detail objectForKey:@"user_items"];
    for (NSString *itemTitle in items)
        [_userItems setValue:@"-" forKey:itemTitle];
    
    self.allItems = [[NSMutableArray alloc]init];
    [self.allItems addObjectsFromArray:self.milageItems.allKeys];
    [self.allItems addObjectsFromArray:self.userItems.allKeys];
    
    
    // get maintenance type
    if ([self.order.detail objectForKey:@"type"] != nil)
        self.maintenaneType = [self.order.detail objectForKey:@"type"];
    
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, 44)];
        
        UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
        
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(resignKeyboard)];
        
        [self.keyboardToolbar setItems:[[NSArray alloc] initWithObjects:extraSpace, done, nil]];
        
        [self.keyboardToolbar setTranslucent:YES];
        [self.keyboardToolbar setTintColor:[UIColor blackColor]];
    }
    
    for (id view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [(UITextField *)view setInputAccessoryView:self.keyboardToolbar];
        }
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) resignKeyboard {
    
    [self.view endEditing:YES];
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
        if (self.allItems.count == 0) return 1;
        else  return self.allItems.count;
    }
    else if (section == SectionReply) {
        if ([[self.order.detail objectForKey:@"type"] isEqualToString:@"unknown"])
            return 1;
        else
            return 3;
    } else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionInfo)
        return 35.f;
    
    else if (indexPath.section == SectionDetail) {
        return 35.f;
    }
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
    else return 05.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"订单信息", @"保养项目", @"商家回复"];
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
    static NSString *identifier = @"itemCell";
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
    CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
    // Configure the cell...
    switch (indexPath.section) {
        case SectionInfo:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"服务项目";
                cell.detailTextLabel.text = @"车辆保养";
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
                } else if ([self.order.status isEqualToString:@"completed"])
                    cell.detailTextLabel.text = @"处理完了";
                else if ([self.order.status isEqualToString:@"canceled"])
                    cell.detailTextLabel.text = @"已撤销";
                else
                    cell.detailTextLabel.text = @"处理中";
            } else if (indexPath.row == 4){
                cell.textLabel.text = @"车牌号";
                cell.detailTextLabel.text = self.order.platenumber;
            } else {
                cell.textLabel.text = @"保养类型";
                NSString *type = [self.order.detail objectForKey:@"type"];
                if ([type isEqualToString:@"unkown"])
                    cell.detailTextLabel.text = @"我不知道什么项目,到店检查";
                else
                    cell.detailTextLabel.text = @"按车辆里程数保养";
            }
            break;
            
        case SectionDetail:
            if (self.allItems.count == 0) {
                cell.detailTextLabel.text = @"没有保养项目";
            } else {
                NSString *itemTitle = [self.allItems objectAtIndex:indexPath.row];
               
                cell.textLabel.text = itemTitle;
                
                MxTextField *textField = [[MxTextField alloc]initWithFrame:CGRectMake(80, 0,  self.view.frame.size.width - 125.f, height)];
                textField.placeholder = @"请输入价格";
                textField.font = [UIFont systemFontOfSize:13.f];
                textField.textAlignment = NSTextAlignmentRight;
                
                textField.name = itemTitle;
                textField.group = @"items";
                textField.mxDelegate = self;
                [textField addRule:[Rules checkIfNumericWithFailureString:@"只能填写数字" forTextField:textField]];
                [cell.contentView addSubview:textField];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40.f, 0, 30, height)];
                label.text = @"元";
                label.font = [UIFont systemFontOfSize:13.f];
                label.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:label];
                
            }
            break;
            
            
        case SectionReply:
            if ([self.maintenaneType isEqualToString:@"unknown"]) {
                if (self.feedbackTextView == nil)
                    self.feedbackTextView = [[SSTextView alloc]initWithFrame:cell.contentView.frame];
                
                [self.feedbackTextView setContentInset:UIEdgeInsetsMake(2, 10, 2, 10)];
                self.feedbackTextView.font = [UIFont systemFontOfSize:14.f];
                self.feedbackTextView.placeholder = @"感谢您的预约";
                self.feedbackTextView.keyboardType = UIKeyboardTypeASCIICapable;
                self.feedbackTextView.returnKeyType = UIReturnKeyDone;
                
                [cell.contentView addSubview:self.feedbackTextView];
            }
            else if (indexPath.row == 0) {
                if (self.timeTextField == nil)
                    self.timeTextField = [[MxTextField alloc]initWithFrame:CGRectMake(80, 0, self.view.frame.size.width - 125, height)];
                [cell.contentView addSubview:self.timeTextField];
                self.timeTextField.font = [UIFont systemFontOfSize:14.f];
                self.timeTextField.placeholder = @"请输入工时";
                self.timeTextField.textAlignment = NSTextAlignmentRight;
                self.timeTextField.keyboardType = UIKeyboardTypeNumberPad;
                self.timeTextField.returnKeyType = UIReturnKeyDone;
                self.timeTextField.contentMode = UIControlContentVerticalAlignmentCenter;
                self.timeTextField.text = self.order.time;
                self.timeTextField.mxDelegate = self;
                [self.timeTextField addRule:[Rules checkIfNumericWithFailureString:@"只能填写数字" forTextField:self.timeTextField]];
                
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, 0, 30, height)];
                label.font = [UIFont systemFontOfSize:14.f];
                label.text = @"小时";
                label.contentMode = UIControlContentVerticalAlignmentCenter;
                [cell.contentView addSubview:label];
                
                cell.textLabel.text = @"工时";
                
            } else if (indexPath.row == 1) {
                if (self.costTextField == nil)
                    self.costTextField = [[MxTextField alloc]initWithFrame:CGRectMake(80, 0, self.view.frame.size.width - 125, height)];
                [cell.contentView addSubview:self.costTextField];
                cell.textLabel.text = @"费用";
                self.costTextField.font = [UIFont systemFontOfSize:14.f];
                self.costTextField.placeholder = @"请输入费用";
                self.costTextField.contentMode = UIControlContentVerticalAlignmentCenter;
                self.costTextField.text = self.order.cost;
                self.costTextField.mxDelegate = self;
                self.costTextField.textAlignment = NSTextAlignmentRight;
                self.costTextField.returnKeyType = UIReturnKeyDone;
                self.costTextField.keyboardType = UIKeyboardTypeNumberPad;
            
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, 0, 30, height)];
                label.font = [UIFont systemFontOfSize:14.f];
                label.text = @"元";
                label.contentMode = UIControlContentVerticalAlignmentCenter;
                [cell.contentView addSubview:label];
                
            } else if (indexPath.row == 2) {
                if (self.feedbackTextView == nil)
                    self.feedbackTextView = [[SSTextView alloc]initWithFrame:cell.contentView.frame];
                
                [self.feedbackTextView setContentInset:UIEdgeInsetsMake(2, 10, 2, 10)];
                self.feedbackTextView.font = [UIFont systemFontOfSize:14.f];
                self.feedbackTextView.placeholder = @"感谢您的预约";
                self.feedbackTextView.keyboardType = UIKeyboardTypeASCIICapable;
                self.feedbackTextView.returnKeyType = UIReturnKeyDone;
                
                [cell.contentView addSubview:self.feedbackTextView];
            } else {}
            
            break;
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
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    if (![self.maintenaneType isEqualToString:@"unknown"]) {
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
        [params setObject:self.costTextField.text forKey:@"cost"];
        [params setObject:self.timeTextField.text forKey:@"time"];
        
        // check wether all items's price is set
        for (NSString *item in self.milageItems.allKeys) {
            NSString *price = [self.milageItems objectForKey:item];
            if (price == nil || [price isEqualToString:@"-"]) {
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"没有填写%@的报价", item] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show:self];
                return;
            }
        }
        
        for (NSString *item in self.userItems.allKeys) {
            NSString *price = [self.userItems objectForKey:item];
            if (price == nil || [price isEqualToString:@"-"]) {
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"没有填写%@的报价", item] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show:self];
                return;
            }
        }
        [params setObject:self.milageItems forKey:@"mileage_items"];
        [params setObject:self.userItems forKey:@"user_items"];
        
    }
    
    if (![self.feedbackTextView.text isEqualToString:@""])
        [params setObject:self.feedbackTextView.text forKey:@"reply"];
    else
        [params setObject:@"感谢您的预约" forKey:@"reply"];
    
    [self setOrderStatus:@"agree" info:params];
    
    // add this order to seller order list
    self.order.reply = [[NSMutableDictionary alloc]init];
    [self.order.reply setValue:self.milageItems forKey:@"mileage_items"];
    [self.order.reply setValue:self.userItems forKey:@"user_items"];
    [self.order.reply setValue:self.costTextField.text forKey:@"cost"];
    [self.order.reply setValue:self.timeTextField.text forKey:@"time"];
    
    SellerModel *seller = [SellerModel sharedClient];
    [seller.orders addObject:self.order];
    
    // remove from local order list
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

- (void)orderDataLoaded {
}

#pragma mark - MxTextFieldDelegate
- (void)mxTextFieldDidEndEditing:(MxTextField *)textField {
    [self resignKeyboard];
    NSString *name = textField.name;
    NSString *price = textField.text;
    NSString *group = textField.group;
    
    if ([price isEqualToString:@""]) return;
    if (![group isEqualToString:@"items"]) return;
    
    if ([_milageItems.allKeys containsObject:name]) {
        [_milageItems setValue:price forKey:name];
    } else {
        [_userItems setValue:price forKey:name];
    }
    
    // get all cost
    NSInteger sumOfCost = 0;
    for (NSString *title in self.milageItems.allKeys) {
        NSString *val = [self.milageItems objectForKey:title];
        if (val != nil && ![val isEqualToString:@"-"]) {
            sumOfCost += val.integerValue;
        }
    }
    for (NSString *title in self.userItems.allKeys) {
        NSString *val = [self.userItems objectForKey:title];
        if (val != nil && ![val isEqualToString:@"-"]) {
            sumOfCost += val.integerValue;
        }
    }
    self.costTextField.text = [NSString stringWithFormat:@"%lu", sumOfCost];
}




@end
