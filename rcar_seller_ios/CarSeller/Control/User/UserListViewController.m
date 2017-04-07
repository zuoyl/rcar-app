//
//  UserListViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "UserListViewController.h"
#import "UserModel.h"
#import "DataArrayModel.h"
#import "UserListItemCell.h"
#import "SellerInfoModel.h"
#import "UserGroupModel.h"
#import "UserGroupNotifyViewController.h"
#import "UserGroupAddViewController.h"
#import "UserAddViewController.h"
#import "SellerModel.h"
#import "MJRefresh.h"
#import "UserListModel.h"


#import "UserChatViewController.h"

@interface UserListViewController ()

@end

@implementation UserListViewController {
    UIBarButtonItem *_addItem;
    UIBarButtonItem *_selectItem;
    SellerModel *_seller;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    self.navigationController.navigationBar.translucent = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"客户管理";
    
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    _addItem = [[UIBarButtonItem alloc]initWithTitle:@"添加客户" style:UIBarButtonItemStylePlain target:self action:@selector(addUser:)];
    [_addItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    _selectItem = [[UIBarButtonItem alloc]initWithTitle:@"添加组" style:UIBarButtonItemStylePlain target:self action:@selector(addGroup:)];
    [_selectItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = @[_addItem, _selectItem];
    
    _seller = [SellerModel sharedClient];
    
    // register nib
    self.tableView.sectionHeaderHeight = 30;
    
    
    __block UserListViewController *blockself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [blockself loadUserList];
    }];
    MJRefreshStateHeader *header = (MJRefreshStateHeader *) self.tableView.mj_header;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [blockself loadUserList];
    }];
    
    if (_seller.groups.count == 0)
        [self loadUserList];
   // [self refreshView];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //UserGroupModel *model = [_users objectAtIndex:indexPath.section];
}

- (void)loadUserList {
    if (![RCar isConnected]) {
     //   [self setCurrentState:ViewStatusNoNetwork];
        return;
    }
    
   // [self setCurrentState:ViewStatusCalling];
    

    // get user list
    DCArrayMapping *mapper1 = [DCArrayMapping mapperForClassElements:[UserGroupModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
   DCArrayMapping *mapper2 = [DCArrayMapping mapperForClassElements:[UserGroupItemModel class] forAttribute:@"users" onClass:[UserGroupModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper1];
   [config addArrayMapper:mapper2];
    
    NSDictionary *params = @{@"role":@"seller", @"seller_id":_seller.seller_id};
    __block UserListViewController *blockself = self;
    
    [RCar GET:rcar_api_seller_user_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *userlist) {
        [blockself.tableView.mj_footer endRefreshing];
        [blockself.tableView.mj_header endRefreshing];
        if (userlist.api_result == APIE_OK) {
            if (userlist.data.count > 0) {
                [_seller.groups removeAllObjects];
                [_seller.groups addObjectsFromArray:userlist.data];
                [blockself.tableView reloadData];
            } else {
                MJRefreshStateHeader *header = (MJRefreshStateHeader *) blockself.tableView.mj_header;
                header.lastUpdatedTimeLabel.hidden = YES;
            }
        }
        else if (userlist.api_result == APIE_USER_NO_EXIST) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有用户，请添加用户" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
        else {
        }
        
    }failure:^(NSString *errorStr) {
        [blockself.tableView.mj_header endRefreshing];
        [blockself.tableView.mj_footer endRefreshing];
    }];
}

- (void)handleLoadError:(NSString *)error {
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show:self];
    
}

- (void)addUser:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"User" bundle:nil];
    UserAddViewController *controller = [story instantiateViewControllerWithIdentifier:@"UserAddView"];
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)addGroup:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"User" bundle:nil];
    UserAddViewController *controller = [story instantiateViewControllerWithIdentifier:@"UserGroupAddView"];
    [self.navigationController pushViewController:controller animated:YES];

    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return _seller.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    UserGroupModel *group = [_seller.groups objectAtIndex:section];
    return (group.opened ? group.users.count:0);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UserListItem";
    SWTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // config cell...
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    [buttons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除用户"];
    [buttons sw_addUtilityButtonWithColor:[UIColor blueColor] title:@"移出组"];
    [cell setRightUtilityButtons:buttons WithButtonWidth:100];
    cell.delegate = self;
    cell.path = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    
    // get user model
    UserGroupModel *userGroup = [_seller.groups objectAtIndex:indexPath.section];
    UserGroupItemModel *user = [userGroup.users objectAtIndex:indexPath.row];
    if (user.image == nil)
        cell.imageView.image = [UIImage imageNamed:@"003"];
    else
        cell.imageView.image = [UIImage imageNamed:user.image];
   // cell.textLabel.textColor = user.isVip ? [UIColor redColor] : [UIColor blackColor];
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.user_id;
    

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UserGroupModel *group = [_seller.groups objectAtIndex:section];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30.f)];
    //headerView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    headerView.backgroundColor = [UIColor colorWithHex:@"A4CDFF"];
    headerView.layer.cornerRadius = 8;
    headerView.layer.masksToBounds = YES;
    
    // header button
    UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width - 90, 30.f)];
    [selectBtn setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn setTitle:group.name forState:UIControlStateNormal];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    selectBtn.imageView.contentMode = UIViewContentModeCenter;
    selectBtn.imageView.clipsToBounds = NO;
    selectBtn.imageView.transform = group.opened ? CGAffineTransformMakeRotation(M_PI_2):CGAffineTransformMakeRotation(0);
    
    selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    selectBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    selectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [selectBtn addTarget:self action:@selector(headerViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.tag = section;
    [headerView addSubview:selectBtn];
    
    // option button
    UIButton *optionBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width - 90, 5, 20.f, 20.f)];
    
    optionBtn.imageView.clipsToBounds = YES;
    [optionBtn setImage:[UIImage imageNamed:@"002"] forState:UIControlStateNormal];
    [optionBtn addTarget:self action:@selector(optionViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    headerView.tag = section;
    [headerView addSubview:optionBtn];
    
    // edit button
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width - 120, 5, 20, 20.f)];
    [editBtn setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    editBtn.imageView.contentMode = UIViewContentModeCenter;
    editBtn.imageView.clipsToBounds = NO;
    editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    editBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [editBtn addTarget:self action:@selector(infoViewClicked:) forControlEvents: UIControlEventTouchUpInside];
    editBtn.tag = section;
    [headerView addSubview:editBtn];
    
    // label
    // numLabel.textAlignment = NSTextAlignmentRight;
    
    
    return headerView;
}

#pragma tableView delegate methods
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.hidesBottomBarWhenPushed = YES;
    UserGroupModel *group = [_seller.groups objectAtIndex:indexPath.section];
    UserGroupItemModel *user = [group.users objectAtIndex:indexPath.row];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"User" bundle:nil];
    UserChatViewController *controller = [story instantiateViewControllerWithIdentifier:@"UserChatView"];
    [controller setValue:user.user_id forKey:@"user_id"];
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - UserHeaderViewDelegate
- (void)headerViewClicked:(id)sender {
    UIButton *button = sender;
    UserGroupModel *group = [_seller.groups objectAtIndex:button.tag];
    group.opened = !group.opened;
    
    [self.tableView reloadData];
}

- (void)optionViewClicked:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
 
    UIButton *button = sender;
    UserGroupModel *group = [_seller.groups objectAtIndex:button.tag];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"User" bundle:nil];
    UserGroupNotifyViewController *controller = [story instantiateViewControllerWithIdentifier:@"UserGroupNotifyView"];
    [controller setValue:group forKey:@"group"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)infoViewClicked:(id)sender  {
     self.hidesBottomBarWhenPushed = YES;
    UIButton *button = sender;
    UserGroupModel *group = [_seller.groups objectAtIndex:button.tag];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"User" bundle:nil];
    UserGroupAddViewController *controller = [story instantiateViewControllerWithIdentifier:@"UserGroupAddView"];
    [controller setValue:group forKey:@"model"];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - SWTabelViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
#if 0
    if (![Reachability reachabilityForInternetConnection]) {
        return;
    }
#endif
    NSIndexPath *indexPath = cell.path;
    UserGroupModel *userGroup = [_seller.groups objectAtIndex:indexPath.section];
    UserModel *user = [userGroup.users objectAtIndex:indexPath.row];
    
    __block UserListViewController *blockself = self;
    if (index == 0) { // delete user
        // delete user in sellers
        for (UserModel *model in _seller.users) {
            if ([model.user_id isEqualToString:user.user_id]) {
                [_seller.users removeObject:model];
            }
        }
        // remove user from group
        for (NSString *name in userGroup.users) {
            if ([user.name isEqualToString:name]) {
                [userGroup.users removeObject:name];
                break;
            }
        }
        
        NSDictionary *params = @{@"role":@"seller", @"seller_id":_seller.seller_id, @"user_id":user.user_id};
        
        [RCar DELETE:rcar_api_seller_user  modelClass:@"APIResponseModel" config:nil  params:params success:^(APIResponseModel *rsp) {
            if (rsp.api_result == APIE_OK) {
                [blockself.tableView reloadData];
            }else {
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show:self];
                return;
                
            }
        } failure:^(NSString *errorStr) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不能连接,请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
            
        }];
        
    } else { // remove user from group
        for (NSString *name in userGroup.users) {
            if ([user.name isEqualToString:name]) {
                [userGroup.users removeObject:name];
                break;
            }
        }
        
        NSDictionary *params = @{@"role":@"seller", @"seller_id":_seller.seller_id, @"user_id":user.user_id, @"group_name":userGroup.name};
        
        [RCar DELETE:rcar_api_seller_user_group  modelClass:@"APIResponseModel" config:nil params:params success:^(APIResponseModel *rsp) {
            if (rsp.api_result == APIE_OK) {
                [blockself.tableView reloadData];
            }else {
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
}

#pragma mark - MyStatusViewDelegate
- (void) onRetryClicked:(StatusView *) statusView {
    
}
- (void) onNoNetworkClicked:(StatusView *) statusView {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
