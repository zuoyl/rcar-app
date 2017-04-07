//
//  UserGroupAddViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 24/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "UserGroupAddViewController.h"
#import "SellerModel.h"
#import "UserModel.h"
#import "UserGroupModel.h"
#import "SSTextView.h"
#import "PickerView.h"
#import "UserAddViewController.h"
#import "SWTableViewCell.h"


@interface UserGroupAddViewController () <PickerViewDelegate, UserAddViewDelegate, SWTableViewCellDelegate>
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation UserGroupAddViewController {
    SellerModel *_seller;
}

@synthesize model;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    
    _seller = [SellerModel sharedClient];
    
    if (self.model == nil) {
        self.navigationItem.title = @"添加用户组";
        self.model = [[UserGroupModel alloc]init];
    } else {
        self.navigationItem.title = @"编辑用户组";
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"删除组" style:UIBarButtonItemStylePlain target:self action:@selector(delGroupBtnClicked:)];
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
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
    if ([segue.identifier isEqualToString:@"add_user"]) {
        [segue.destinationViewController setValue:self.model forKey:@"groupModel"];
        [segue.destinationViewController setValue:self forKey:@"delegate"];
        return;
    }
    if ([segue.identifier isEqualToString:@"show_user_info"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UserModel *user = [self.model.users objectAtIndex:indexPath.row];
        [segue.destinationViewController setValue:user.user_id forKey:@"user_id"];
        return;
    }
    
}


#pragma mark - UITableViewDelegate
enum {
    NameSection = 0,
    AddSection,
    UserListSection,
    SectionMax,
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SectionMax;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == NameSection) return 1;
    else if (section == AddSection) return 2;
    else if (section == UserListSection) {
        if (self.model.users.count == 0) return 1;
        else return self.model.users.count;
    } else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > NameSection)
       return 30.f;
    else return 0.5f;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == UserListSection) return 40.f;
    else return 0.5f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"", @"用户添加方式", @"用户列表"];
    return [titles objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == UserListSection) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.f)];
        if(self.submitBtn == nil) {
            self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
            [self.submitBtn setTitle:@"保存" forState:UIControlStateNormal];
            [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.submitBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
            
            [self.submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        [view addSubview:self.submitBtn];
        return view;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UserGroupAddItemCell";
    SWTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[SWTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    //else {
    //    for (UIView *view in cell.subviews)
    //        [view removeFromSuperview];
    //}
    // config the cell
    switch (indexPath.section) {
        case NameSection:
            if (self.nameTextField == nil)
                self.nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, cell.frame.size.width - 125, 35.f)];
            if (self.model.name != nil && ![self.model.name isEqualToString:@""])
                self.nameTextField.text = self.model.name;
            else
                self.nameTextField.placeholder = @"请输入组名称";
            self.nameTextField.keyboardType = UIKeyboardTypeAlphabet;
            self.nameTextField.returnKeyType = UIReturnKeyDone;
            self.nameTextField.font = [UIFont systemFontOfSize:17.f];
            self.nameTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            [cell.contentView addSubview:self.nameTextField];
            cell.textLabel.text = @"组名称";
            break;
            
        case AddSection:
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            if (indexPath.row == 0) {
                cell.textLabel.text = @"点击添加新的用户";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"从已有用户列表中选择用户";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (_seller.users.count == 0)
                    cell.textLabel.textColor = [UIColor lightGrayColor];
            } else {}
            break;
            
        case UserListSection:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            
            if (self.model.users.count == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"该组别没有添加用户";
            } else {
                UserGroupItemModel *user = [self.model.users objectAtIndex:indexPath.row];
                cell.textLabel.text = user.name;
                cell.detailTextLabel.text = user.user_id;
                
                NSMutableArray *buttons = [[NSMutableArray alloc]init];
                [buttons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
                [cell setRightUtilityButtons:buttons WithButtonWidth:50];
                cell.delegate = self;
                cell.path = indexPath;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == AddSection && indexPath.row == 0) {
        if ([self.nameTextField.text isEqualToString:@""]) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"组名没有填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
#if 0
        // check wether the group name already exist
        for (UserGroupModel *group in _seller.groups) {
            if (group.name != nil && [group.name isEqualToString:self.nameTextField.text]) {
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"该组已经存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show:self];
                return;
            }
        }
#endif
        self.model.name = self.nameTextField.text;
        [self performSegueWithIdentifier:@"add_user" sender:self];
        
    } else if (indexPath.section == AddSection && indexPath.row == 1) {
        if (_seller.users.count > 0) {
            NSMutableArray *users = [[NSMutableArray alloc]init];
            for (UserModel *user in _seller.users) {
                [users addObject:user.name];
            }
            PickerView *picker = [[PickerView alloc]initPickviewWithArray: users isHaveNavControler:false];
            picker.delegate = self;
            [picker show];
            return;
        }
    } else if (indexPath.section == UserListSection && self.model.users.count > 0) {
        [self performSegueWithIdentifier:@"show_user_info" sender:self];
    }
}
#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    UserModel *user = [self.model.users objectAtIndex:cell.path.row];
    [self.model.users removeObject:user];
    [self.tableView reloadData];
}

#pragma mark - PickerViewDelegae
-(void)pickerViewDone:(PickerView *)pickView result:(NSString *)result {
    // check wether the user name already exist in list
    for (UserModel *user in self.model.users) {
        if ([result isEqualToString:user.name]) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"该用户已经加入改组" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
    }
    // get user model by name
    for (UserModel *user in _seller.users) {
        if (user.name != nil && [user.name isEqualToString:result]) {
            UserGroupItemModel *item = [[UserGroupItemModel alloc]init];
            item.name = user.name;
            item.user_id = user.user_id;
            [self.model.users addObject:item];
            [self.tableView reloadData];
            break;
        }
    }
}

#pragma mark - UserAddViewDelegate
- (void)userAddView:(UserModel *)user {
    UserGroupItemModel *item = [[UserGroupItemModel alloc]init];
    item.name = user.name;
    item.user_id = user.user_id;
    item.online = [NSNumber numberWithInt:0];
    [self.model.users addObject:user];
    [self.tableView reloadData];
    
}

- (void)submitBtnClicked:(id)sender {
    if ([self.nameTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户组名不能为空" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    // check wethere the group exist
    for (UserGroupModel *group in _seller.groups) {
        if ([group.name isEqualToString:self.nameTextField.text]) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"新添加的组已经存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
    }
    self.model.name = self.nameTextField.text;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"role":@"seller", @"seller_id":_seller.seller_id, @"group_name":self.model.name, @"users":self.model.users}];
    
    if (self.model.group_id != nil && ![self.model.group_id isEqualToString:@""])
        [params setValue:self.model.group_id forKey:@"group_id"];
    
    
    __block UserGroupAddViewController *blockself = self;
    [RCar POST:rcar_api_seller_user_group modelClass:nil config:nil params:params success:^(NSDictionary *data) {
        NSString *result = [data objectForKey:@"api_result"];
        if (result.integerValue == APIE_OK) {
            if (blockself.model.group_id == nil) { // new group
                blockself.model.group_id = [data objectForKey:@"group_id"];
                [_seller.groups addObject:blockself.model];
            }
            if (blockself.delegate)
                [blockself.delegate userGroupAddCompleted:blockself.model];
            [blockself.navigationController popViewControllerAnimated:YES];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
            
        }
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不能连接,请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
        
    }];
}

- (void)delGroupBtnClicked:(id)sender {
    
    if (self.model.group_id == nil || [self.model.group_id isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"未知的组别情报" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"role":@"seller", @"seller_id":_seller.seller_id, @"group_id":self.model.group_id}];
    
    __block UserGroupAddViewController *blockself = self;
    [RCar DELETE:rcar_api_seller_user_group modelClass:nil config:nil params:params success:^(NSDictionary *data) {
        NSString *result = [data objectForKey:@"api_result"];
        if (result.integerValue == APIE_OK) {
            [_seller.groups removeObject:blockself.model];
            [blockself.navigationController popViewControllerAnimated:YES];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
        
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不能连接,请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
        
    }];
    
}
@end
