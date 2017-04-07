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
#import "SellerModel.h"
#import "NotifyCenterModel.h"
#import "FBKVOController.h"
#import "MJRefresh.h"
#import "SellerServiceModel.h"
#import "OrderDetailModel.h"
#import "ReadDB.h"


@interface OrderListViewController ()
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) ReadDB *readdb;
@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = @"订单一览";
    self.hidesBottomBarWhenPushed = YES;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.orders = [[NSMutableArray alloc]init];
    self.hasMore = false;
    self.offset = 0;
    
    self.readdb = [[ReadDB alloc]init];
    
    // register kvm
    __block OrderListViewController *blockself = self;
    NotifyCenterModel *notifyCenter = [NotifyCenterModel sharedClient];
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:notifyCenter keyPath:@"orders"
                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                          block:^(id observer, id object, NSDictionary *change) {
        // get new data by change[NSKeyValueChangeNewKey];
        NSDictionary *info = change[NSKeyValueChangeNewKey];
        NSString *order_id = [info objectForKey:@"order_id"];
        [blockself loadOrders:order_id];
    }];
    
    
    if (self.orders.count == 0) {
        [self loadOrders:nil];
    } else {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [blockself loadOrders:nil];
        }];
    }
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [blockself loadOrders:nil];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.orders.count > 0) {
        [self.readdb isExistById:self.orders];
        [self.tableView reloadData];
    }
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
    return [self.orders count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"OrderItemCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    } else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    
    OrderDetailModel *order = [self.orders objectAtIndex:indexPath.row];
    
    
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80.f, 5.f, cell.frame.size.width - 100, 20.f)];
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    
    if ([order.order_type isEqualToString:kOrderTypeBidding] && ![order.order_service_type isEqualToString:@""]) {
        titleLabel.text = order.order_service_type;
        [cell.imageView setImage:[UIImage imageNamed: [SellerServiceInfoList imageNameOfService:order.order_service_type]]];
        
    } else if ([order.order_type isEqualToString:kOrderTypeBook] && order.detail != nil) {
        NSArray *services = [order.detail objectForKey:@"services"];
        if (services.count > 0) {
            NSDictionary *service = [services objectAtIndex:0];
            titleLabel.text = [service objectForKey:@"service_type"];
            [cell.imageView setImage:[UIImage imageNamed: [SellerServiceInfoList imageNameOfService:titleLabel.text]]];
        } else {
            titleLabel.text = @"错误订单";
            [cell.imageView setImage:[UIImage imageNamed: @"bus"]];
        }
    }
    [cell.imageView setFrame:CGRectMake(5, 10, 50, 50)];
    [cell.contentView addSubview:titleLabel];

    
    
    // time label
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80.f, 30.f, cell.frame.size.width - 45.f, 10)];
    timeLabel.font = [UIFont systemFontOfSize:12.f];
    timeLabel.text = @"订单时间:";
    timeLabel.text = [timeLabel.text stringByAppendingString:order.date_time];
    [cell.contentView addSubview:timeLabel];
    
    // user label
    UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(80.f, 50.f, cell.frame.size.width - 45.f, 10)];
    userLabel.font = [UIFont systemFontOfSize:12.f];
    userLabel.text = @"用户:";
    if (order.user_name != nil && ![order.user_name isEqualToString:@""])
        userLabel.text = [userLabel.text stringByAppendingString:order.user_name];
    else
        userLabel.text = [userLabel.text stringByAppendingString:order.user_id];
    
    [cell.contentView addSubview:userLabel];
    
    
    // status label
    if ([order.status isEqualToString:@"new"])
        cell.detailTextLabel.text = @"未处理";
    else if ([order.status isEqualToString:@"completed"])
        cell.detailTextLabel.text = @"处理完";
    else if ([order.status isEqualToString:@"canceled"])
        cell.detailTextLabel.text = @"已撤销";
    else
        cell.detailTextLabel.text = @"未知状态";
    
    
    // update text color according to reading status
    if (order.read ==  YES) {
        titleLabel.textColor = [UIColor grayColor];
        timeLabel.textColor = [UIColor grayColor];
        userLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderDetailModel *order = [self.orders objectAtIndex:indexPath.row];
    [self.readdb save:order.order_id];
   
    if ([order.order_type isEqualToString:kOrderTypeBook]) {
        [self performSegueWithIdentifier:@"show_order_detail_book" sender:self];
    } else if ([order.order_type isEqualToString:kOrderTypeBidding]) {
        if ([order.order_service_type isEqualToString:kServiceType_CarMaintenance])
            [self performSegueWithIdentifier:@"show_order_detail_maintenance" sender:self];
        if ([order.order_service_type isEqualToString:kServiceType_CarFault])
            [self performSegueWithIdentifier:@"show_order_detail_fault" sender:self];
    } else {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"未知业务类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *controller = segue.destinationViewController;
    controller.hidesBottomBarWhenPushed = YES;
    if ([segue.destinationViewController respondsToSelector:@selector(setOrder_id:)]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        OrderDetailModel *order = [self.orders objectAtIndex:indexPath.row];
        [segue.destinationViewController setValue:order forKey:@"order"];
        [segue.destinationViewController setValue:self.orders forKey:@"allOrders"];
        return;
    }
    
}

- (void)loadOrders:(NSString *)order_id {

    SellerModel *seller = [SellerModel sharedClient];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary: @{@"role":@"seller", @"seller_id":seller.seller_id, @"offset":[NSNumber numberWithInteger:self.orders.count], @"num":[NSNumber numberWithInteger:10]}];
    if (order_id != nil && ![order_id isEqualToString:@""])
        [params setObject:order_id forKey:@"order_id"];
    
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[OrderDetailModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    __block OrderListViewController *blockself = self;
    [RCar GET:rcar_api_seller_order_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        // ending refreshing
        [blockself.tableView.mj_header endRefreshing];
        [blockself.tableView.mj_footer endRefreshing];
        
        // load data
        if (dataModel.api_result == APIE_OK) {
            if (dataModel.data.count > 0) {
                // add valid order into local order list
                for (OrderDetailModel *order in dataModel.data) {
                    if (order.order_id != nil && order.order_type != nil && order.detail != nil) {
                        order.id = order.order_id;
                        [blockself.orders addObject:order];
                    }
                }
                [blockself.readdb isExistById:blockself.orders];
                
                [blockself.tableView reloadData];
                if (dataModel.data.count == 10) { // there are more data
                    if (blockself.tableView.mj_footer == nil)
                        blockself.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
                            [blockself loadOrders:nil];
                        }];
                }
            }
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
        }
        
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
    
    }];
}

@end
