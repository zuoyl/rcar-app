//
//  UserOrderListViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 16/8/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "UserOrderListViewController.h"

#import "OrderModel.h"
#import "DataArrayModel.h"
#import "SellerModel.h"
#import "SellerServiceModel.h"
#import "OrderDetailModel.h"

@interface UserOrderListViewController () <MxAlertViewDelegate>
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong) NSMutableDictionary *sortedOrders;
@property (nonatomic, strong) NSMutableArray *days;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) NSMutableArray *orders;
@end

@implementation UserOrderListViewController
@synthesize user_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    
    self.navigationItem.title = @"用户订单";
    self.hidesBottomBarWhenPushed = YES;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.hasMore = false;
    self.offset = 0;
    self.sortedOrders = [[NSMutableDictionary alloc]init];
    self.days = [[NSMutableArray alloc]init];
    self.orders = [[NSMutableArray alloc]init];
    [self loadUserOrders];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeOrderList:(NSArray *)orderList {
    // get all days
    for (OrderModel *order in orderList) {
        NSString *day = [order.date_time substringToIndex:10];
        // check wether the day already exist in days
        NSInteger index = 0;
        for (;index < self.days.count; index++) {
            if ([self.days[index] isEqualToString:day]) break;
        }
        if (index >= self.days.count)
            [self.days addObject:day];
    }
    // for each days, collect order for the days
    for (NSString *day in self.days) {
        NSMutableArray * orders = [[NSMutableArray alloc]init];
        for (OrderModel *order in orderList) {
            NSString *orderDate = [order.date_time substringToIndex:10];
            if (orderDate != nil && [orderDate isEqualToString:day])
                [orders addObject:order];
        }
        [self.sortedOrders setObject:orders forKey:day];
    }
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.days.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *day = [self.days objectAtIndex:section];
    NSArray *orders = [self.sortedOrders objectForKey:day];
    return orders.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *day = [self.days objectAtIndex:section];
    return day;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.hasMore && section == self.days.count) {
        return 40.f;
    } else {
        return 0.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *day = [self.days objectAtIndex:section];
    NSArray *orders = [self.sortedOrders objectForKey:day];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30.f)];
    view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 0, 120, 30.f)];
    label1.text = day;
    label1.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width - 80, 0, 70, 30.f)];
    label2.text = [NSString stringWithFormat:@"共%lu件", orders.count];
    label1.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:label2];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *loadView = nil;
    if (self.hasMore) {
        loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30.f)];
        UIButton *button = [[UIButton alloc]initWithFrame:loadView.frame];
        [button setTitle:@"点击加载更多" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.f];
        button.backgroundColor = [UIColor colorWithHex:@"2480ff"];
        [button addTarget:self action:@selector(loadMoreOrder:) forControlEvents:UIControlEventTouchUpInside];
        [loadView addSubview:button];
    }
    return loadView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UserOrderItemCell";
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
    
    NSString *day = [self.days objectAtIndex:indexPath.section];
    NSArray *orders = [self.sortedOrders objectForKey:day];
    OrderDetailModel *order = [orders objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80.f, 5.f, cell.frame.size.width - 100, 20.f)];
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    
    if (order.order_service_type != nil && [order.order_service_type isEqualToString:@""]) {
        titleLabel.text = order.order_service_type;
        [cell.imageView setImage:[UIImage imageNamed: [SellerServiceInfoList imageNameOfService:order.order_service_type]]];
        
    } else if (order.detail != nil) {
        NSArray *services = [order.detail objectForKey:@"services"];
        if (services != nil && services.count == 1) {
            NSDictionary *service = [services objectAtIndex:0];
            titleLabel.text = [service objectForKey:@"service_type"];
            [cell.imageView setImage:[UIImage imageNamed: [SellerServiceInfoList imageNameOfService:titleLabel.text]]];
        } else {
            titleLabel.text = @"预订多项服务";
            [cell.imageView setImage:[UIImage imageNamed: @"other"]];
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
    
    // status label
    if ([order.status isEqualToString:@"new"])
        cell.detailTextLabel.text = @"未处理";
    else if ([order.status isEqualToString:@"completed"])
        cell.detailTextLabel.text = @"处理完";
    else if ([order.status isEqualToString:@"canceled"])
        cell.detailTextLabel.text = @"已撤销";
    else
        cell.detailTextLabel.text = @"已确定";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *day = [self.days objectAtIndex:indexPath.section];
    NSArray *orders = [self.sortedOrders objectForKey:day];
    OrderDetailModel *order = [orders objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    UIViewController *controller = nil;
    if ([order.order_type isEqualToString:kOrderTypeBook]) {
        controller = [storyboard instantiateViewControllerWithIdentifier:@"MyOrderDetailBookView"];
        
    } else if ([order.order_type isEqualToString:kOrderTypeBidding]) {
        if ([order.order_service_type isEqualToString:kServiceType_CarMaintenance]) {
            controller = [storyboard instantiateViewControllerWithIdentifier:@"MyOrderDetailMaintenanceView"];
        }
        else if ([order.order_service_type isEqualToString:kServiceType_CarFault]) {
            controller = [storyboard instantiateViewControllerWithIdentifier:@"MyOrderDetailFaultView"];
        }
    } else {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"未知业务类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    if (controller != nil) {
        [controller setValue:order.order_id forKey:@"order_id"];
        [controller setValue:order.user_id forKey:@"user_id"];
        [self.navigationController pushViewController:controller animated: YES];
        return;
    }
}
#pragma mark - MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)loadMoreOrder:(id)sender {
    [self loadUserOrders];
}

- (void)addOrder:(OrderModel *)order {
    [self.orders addObject:order];
    
    NSArray *sortedArray = [self.orders sortedArrayUsingComparator:^(id obj1, id obj2) {
        OrderModel *order1 = obj1;
        OrderModel *order2 = obj2;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        NSDate *date1 = [formatter dateFromString:order1.date_time];
        NSDate *date2 = [formatter dateFromString:order2.date_time];
        
        NSComparisonResult result = [date1 compare:date2];
        switch(result) {
            case NSOrderedAscending:
                return NSOrderedDescending;
            case NSOrderedDescending:
                return NSOrderedAscending;
            case NSOrderedSame:
                return NSOrderedSame;
            default:
                return NSOrderedSame;
        }
    }];
    [self.orders removeAllObjects];
    [self.orders addObjectsFromArray:sortedArray];
}




- (void)loadUserOrders {
    SellerModel *seller = [SellerModel sharedClient];
    
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[OrderModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    NSDictionary *params = @{@"role":@"seller", @"seller_id":seller.seller_id, @"offset":[NSNumber numberWithInteger:self.offset], @"num":[NSNumber numberWithInteger:10], @"user_id":self.user_id};
    __block UserOrderListViewController *blockself = self;
    [RCar GET:rcar_api_seller_order_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            if (dataModel.data.count == 10) {
                blockself.hasMore = true;
                blockself.offset += dataModel.data.count;
                for (OrderModel *order in dataModel.data)
                     [blockself addOrder:order];
                [blockself makeOrderList:blockself.orders];
                [blockself.tableView reloadData];
            } else if (dataModel.data.count < 10 && dataModel.data.count > 0) {
                blockself.hasMore = false;
                blockself.offset += dataModel.data.count;
                for (OrderModel *order in dataModel.data)
                    [blockself addOrder:order];
                
                [blockself makeOrderList:blockself.orders];
                [blockself.tableView reloadData];
            } else {
                blockself.hasMore = false;
                [blockself.tableView reloadData];
            }
        } else if (dataModel.api_result == APIE_USER_NO_EXIST) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"该用户是未注册用户" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
        }
        
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        
    }];
}
@end