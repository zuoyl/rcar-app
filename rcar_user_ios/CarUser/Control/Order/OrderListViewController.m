//
//  OrderListViewController.m
//  CarUser
//
//  Created by jenson.zuo on 5/8/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderModel.h"
#import "DataArrayModel.h"
#import "UserInfoModel.h"
#import "UserModel.h"
#import "OrderWaitingViewController.h"
#import "SWTableViewCell.h"
#import "LoginViewController.h"
#import "StatusView.h"
#import "MJRefresh.h"
#import "OrderModel.h"
#import "OrderDetailModel.h"
#import "OrderDetailBookViewController.h"
#import "OrderDetailFaultViewController.h"
#import "OrderDetailMaintenanceViewController.h"

@interface OrderListViewController () <SWTableViewCellDelegate, MxAlertViewDelegate, LoginViewDelegate, StatusViewDelegate>
@property (nonatomic, strong) StatusView *statusView;
@property (nonatomic, strong) ReadDB *readdb;

@end


enum {
    AlertReason_DeleteOrder = 0x01000,
    AlertReason_Login,
};
@implementation OrderListViewController {
    UserModel *_user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = sel
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationItem.title = @"我的订单";
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.statusView = [[StatusView alloc]initWithFrame:self.view.bounds];
    [self.statusView setStatus:ViewStatusNormal];
    [self.view addSubview:self.statusView];
    [self.view bringSubviewToFront:self.statusView];
   
    
    self.readdb = [[ReadDB alloc]init];
    
    _user = [UserModel sharedClient];
    if (![_user isLogin]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(loginBtnClicked:)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户未登录，不能取得用户信息" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:@"登录", nil];
        alert.tag = AlertReason_Login;
        [alert show:self];
        return;
    }
    __block OrderListViewController *blockself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [blockself loadAllOrderList];
    }];
    
   if (_user.orders.count == 0)
       [blockself loadAllOrderList];
    else
        [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
    if (_user.orders.count > 0)
        [self.readdb isExistById:_user.orders];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_user.orders count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"orderItemCell";
    SWTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    } else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    OrderDetailModel *order = [_user.orders objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80.f, 5.f, cell.frame.size.width - 100, 20.f)];
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    if (order.order_service_type != nil && ![order.order_service_type isEqualToString:@""]) {
        titleLabel.text = order.order_service_type;
        [cell.imageView setImage:[UIImage imageNamed: [ServiceInfoList imageNameOfService:order.order_service_type]]];
        
    } else if (order.detail != nil) {
        NSArray *services = [order.detail objectForKey:@"services"];
        
        if (services != nil && services.count == 1) {
            NSDictionary *service = [services objectAtIndex:0];
            titleLabel.text = [service objectForKey:@"service_type"];
            [cell.imageView setImage:[UIImage imageNamed: [ServiceInfoList imageNameOfService:titleLabel.text]]];
        } if (services != nil && services.count > 1) {
            titleLabel.text = @"预订多项服务";
            [cell.imageView setImage:[UIImage imageNamed: @"other"]];
        } else if (services == nil){
            titleLabel.text = @"订单状态错误";
            [cell.imageView setImage:[UIImage imageNamed: @"other"]];
        }
    }
    [cell.imageView setFrame:CGRectMake(5, 10, 50, 50)];

    
   
   // NSString *name = [order.target_seller objectAtIndex:0];
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(80.f, 50.f, cell.frame.size.width - 45.f, 10)];
    addressLabel.font = [UIFont systemFontOfSize:12.f];
    addressLabel.text = @"订单号:";
    addressLabel.text = [addressLabel.text stringByAppendingString:order.order_id];
    [cell.contentView addSubview:addressLabel];
    
       // [cell.imageView setImage:[UIImage imageNamed:@"bus"]];
    
    
    [cell.contentView addSubview:titleLabel];
    
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80.f, 30.f, cell.frame.size.width - 45.f, 10)];
    timeLabel.font = [UIFont systemFontOfSize:12.f];
    timeLabel.text = @"预约时间:";
    timeLabel.text = [timeLabel.text stringByAppendingString:order.date_time];
    [cell.contentView addSubview:timeLabel];
    
    if ([order.status isEqualToString:@"new"])
        cell.detailTextLabel.text = @"未处理";
    else if ([order.status isEqualToString:@"completed"])
        cell.detailTextLabel.text = @"处理完";
    else if ([order.status isEqualToString:@"canceled"])
        cell.detailTextLabel.text = @"已撤销";
    else
        cell.detailTextLabel.text = @"已确定";
    
    // SWTableViewCell
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    [buttons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    [cell setRightUtilityButtons:buttons WithButtonWidth:50];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderModel *order = [_user.orders objectAtIndex:indexPath.row];
   
    if ([order.order_type isEqualToString:@"books"]) {
        [self performSegueWithIdentifier:@"show_order_detail_book" sender:self];
        
    } else if ([order.order_type isEqualToString:@"bidding"]) {
        if ([order.order_service_type isEqualToString:kServiceType_CarMaintenance])
            [self performSegueWithIdentifier:@"show_order_detail_maintenance" sender:self];
        
        else if ([order.order_service_type isEqualToString:kServiceType_CarFault])
            [self performSegueWithIdentifier:@"show_order_detail_fault" sender:self];
        
    } else {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"位置业务类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
}



#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    segue.destinationViewController.hidesBottomBarWhenPushed = YES;
    if ([segue.identifier isEqualToString:@"show_order_waiting"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        OrderModel *order = [_user.orders objectAtIndex:indexPath.row];
        [segue.destinationViewController setValue:order.order_id forKey:@"order_id"];
        [segue.destinationViewController setValue:order.order_service_type forKey:@"order_type"];
        [segue.destinationViewController setValue:self forKey:@"rootController"];
        return;
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setOrder:)]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        OrderModel *order = [_user.orders objectAtIndex:indexPath.row];
        [segue.destinationViewController setValue:order forKey:@"order"];
        return;
    }
    
}



#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"是否要删除本件订单"
                                                  delegate:self cancelButtonTitle:@"删除"
                                         otherButtonTitles:@"取消", nil];
    alert.tag = AlertReason_DeleteOrder;
    [alert show:self];
    return;
}

#pragma mark - MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertReason_DeleteOrder && buttonIndex == 0) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self deleteOrder:indexPath.row];
        return;
    }
    
    if (alertView.tag == AlertReason_Login && buttonIndex == 0) {
        [self.statusView setStatus:ViewStatusNoLogin];
        return;
    }
    
    if (alertView.tag == AlertReason_Login && buttonIndex == 1) {
        NSIndexPath *indexPath  = [self.tableView indexPathForSelectedRow];
        LoginViewController *loginController = [LoginViewController initWithDelegate:self tag:indexPath.row];
        loginController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginController animated:YES];
        return;
    }
    
}
#pragma mark - commonFunctions
- (void)deleteOrder:(NSInteger)index {
    OrderModel *order = [_user.orders objectAtIndex:index];
    
    NSDictionary *params = @{@"role":@"user", @"user_id":_user.user_id, @"order_id":order.order_id};
    __block OrderListViewController *blockself = self;
    
    [RCar DELETE:rcar_api_user_order modelClass:@"APIResponseModel" config:nil params:params success:^(APIResponseModel *result) {
        if (result.api_result == APIE_OK) {
            [_user.orders removeObjectAtIndex:index];
            [blockself.tableView reloadData];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
        
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
    }];
    
}

-(void)loadMoreOrder:(id)sender {
    [self loadAllOrderList];
}

- (void)reloadAllOrderList {
    [self loadAllOrderList];
}

- (void)loadAllOrderList {
    
    UserModel *user = [UserModel sharedClient];
    
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[OrderDetailModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    NSNumber *offset = [NSNumber numberWithInteger:0];
    
    NSDictionary *params = @{@"role":@"user", @"user_id":user.user_id, @"offset":offset, @"num":[NSNumber numberWithInteger:10]};
    __block OrderListViewController *blockself = self;
    [RCar GET:rcar_api_user_order_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        // ending refreshing
        [blockself.tableView.mj_header endRefreshing];
        [blockself.tableView.mj_footer endRefreshing];
        
        // load data
        if (dataModel.api_result == APIE_OK) {
            if (dataModel.data.count > 0) {
                [_user.orders addObjectsFromArray:dataModel.data];
                [blockself.readdb isExistById:_user.orders];
                [blockself.tableView reloadData];
                if (dataModel.data.count < 10) {
                    [blockself.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
        }
    } failure:^(NSString *errorStr) {
        [blockself.tableView.mj_footer endRefreshing];
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        
    }];
}
#pragma mark - LonginViewDelegate
- (void)onLoginSuccessed :(NSInteger)tag{
    self.navigationItem.rightBarButtonItem.title = @"注销";
    [self.statusView setStatus:ViewStatusNormal];
    [self loadAllOrderList];
    
    __block OrderListViewController *blockself = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [blockself loadAllOrderList];
    }];
    

}
- (void)onLoginFailed:(NSInteger)tag {
    [self.statusView setStatus:ViewStatusNoLogin];
}

#pragma mark - StatusViewDelegate 
- (void) onLoginClicked:(StatusView *)statusView {
    LoginViewController *loginController = [LoginViewController initWithDelegate:self tag:0];
    loginController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginController animated:YES];
}

- (void)loginBtnClicked:(id)sender {
    if (!_user.isLogin) { // login
        LoginViewController *loginController = [LoginViewController initWithDelegate:self tag:0];
        loginController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginController animated:YES];
    } else {
        // unlogin
        __block OrderListViewController *blockself = self;
        NSDictionary *params = @{@"role":@"user", @"user_id":_user.user_id};
        [RCar DELETE:rcar_api_user_session modelClass:@"APIResponseModel" config:nil params:params success:^(APIResponseModel *model) {
            if (model.api_result == APIE_OK) {
                blockself.navigationItem.rightBarButtonItem.title = @"登录";
                [_user setLoginStatus:NO];
                [_user clearAllData];
                [_user.orders removeAllObjects];
                [blockself.tableView reloadData];
                [blockself.tableView.mj_header endRefreshing];
                [blockself.tableView.mj_footer endRefreshing];
            } else {
                [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
            }
        }failure:^(NSString *errorStr) {
            [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
        }];
        
    }
    
}


@end
