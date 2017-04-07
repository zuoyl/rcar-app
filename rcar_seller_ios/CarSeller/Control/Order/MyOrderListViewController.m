//
//  TodoListViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 26/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "OrderModel.h"
#import "DataArrayModel.h"
#import "SellerModel.h"
#import "SellerServiceModel.h"
#import "OrderDetailModel.h"
#import "MyOrderDetailViewController.h"
#import "ReadDB.h"

@interface MyOrderListViewController ()
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong) NSMutableDictionary *sortedOrders;
@property (nonatomic, strong) NSMutableArray *days;
@property (nonatomic, strong) NSMutableDictionary *dayGrouped;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) ReadDB *readdb;
@end

@implementation MyOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    
    self.navigationItem.title = @"我的订单";
    self.hidesBottomBarWhenPushed = YES;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.hasMore = false;
    self.offset = 0;
    self.sortedOrders = [[NSMutableDictionary alloc]init];
    self.days = [[NSMutableArray alloc]init];
    self.dayGrouped = [[NSMutableDictionary alloc]init];
    self.readdb = [[ReadDB alloc]init];
    
    SellerModel *seller = [SellerModel sharedClient];
    if (seller.orders.count == 0) {
        [self loadMyOrders];
    } else {
        [self makeOrderList:seller.orders];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    SellerModel *seller = [SellerModel sharedClient];
    if (seller.orders.count > 0) {
 //       [self.readdb isExistById:seller.orders];
        [self.tableView reloadData];
    }
    
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
        [self.dayGrouped setObject:[NSNumber numberWithBool:YES] forKey:day];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.days.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *day = [self.days objectAtIndex:section];
    BOOL opened = [[self.dayGrouped objectForKey:day] boolValue];
    if (opened == NO)
        return 0;
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
    return 25.f;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *day = [self.days objectAtIndex:section];
    NSArray *orders = [self.sortedOrders objectForKey:day];
    CGFloat height = [self tableView:self.tableView heightForHeaderInSection:section];
    BOOL opened = [[self.dayGrouped objectForKey:day] boolValue];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, height)];
    view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    
    // add selection button
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, height)];
    [button setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeCenter;
    button.imageView.clipsToBounds = NO;
    button.imageView.transform = opened ? CGAffineTransformMakeRotation(M_PI_2):CGAffineTransformMakeRotation(0);
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button addTarget:self action:@selector(orderDaysViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = section;
    [view addSubview:button];
    
    
    // add  time label
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(25.f, 0, 120, height)];
    label1.text = day;
    label1.font = [UIFont systemFontOfSize:13.f];
    label1.contentMode = UIControlContentVerticalAlignmentCenter;
    label1.textAlignment = NSTextAlignmentLeft;
    label1.textColor = [UIColor lightGrayColor];
    
    [view addSubview:label1];
    
    // add number label
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width - 80, 0, 70, height)];
    label2.text = [NSString stringWithFormat:@"共%lu件", orders.count];
    label2.font = [UIFont systemFontOfSize:13.f];
    label2.contentMode = UIControlContentVerticalAlignmentCenter;
    label2.textAlignment = NSTextAlignmentRight;
    label2.textColor = [UIColor lightGrayColor];
    
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
    static NSString *cellIdentifier = @"MyOrderItemCell";
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
    
    if ([order.order_type isEqualToString:kOrderTypeBidding]) {
        if ([order.order_service_type isEqualToString:kServiceType_CarClean]) {
            titleLabel.text = @"洗车";
            [cell.imageView setImage:[UIImage imageNamed:@"bus"]];
        }
        else if ([order.order_service_type isEqualToString:kServiceType_CarMaintenance]) {
            titleLabel.text = @"车辆保养";
            [cell.imageView setImage:[UIImage imageNamed:@"bus"]];
        }
        else if ([order.order_service_type isEqualToString:kServiceType_CarFault]) {
            titleLabel.text = @"故障维修";
            [cell.imageView setImage:[UIImage imageNamed:@"bus"]];
        }
    } else if ([order.order_type isEqualToString:kOrderTypeBook]) {
        NSArray *services = [order.detail objectForKey:@"services"];
        
        if(services != nil && services.count == 1) {
            NSString *serviceType = [[services objectAtIndex:0] objectForKey:@"service_type"];
            if ([serviceType isEqualToString:kServiceType_CarClean])
                titleLabel.text = @"洗车";
            else if ([serviceType isEqualToString:kServiceType_CarMaintenance])
                titleLabel.text = @"车辆保养";
            else if ([serviceType isEqualToString:kServiceType_CarFault])
                titleLabel.text = @"故障维修";
            else
                titleLabel.text = @"商家服务预约";
        } else {
            titleLabel.text = [NSString stringWithFormat:@"商家服务预约(%lu项)", (unsigned long)services.count];
        }
        [cell.imageView setFrame:CGRectMake(5, 10, 50, 50)];
        [cell.imageView setImage:[UIImage imageNamed:@"bus"]];
        
    }
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
    if (order.user_name == nil || [order.user_name isEqualToString:@""])
        userLabel.text = [userLabel.text stringByAppendingString:order.user_id];
    else
        userLabel.text = [userLabel.text stringByAppendingString:order.user_name];
    [cell.contentView addSubview:userLabel];
    
    
    // status label
    if ([order.status isEqualToString:@"new"])
        cell.detailTextLabel.text = @"未处理";
    else if ([order.status isEqualToString:@"completed"])
        cell.detailTextLabel.text = @"处理完";
    else if ([order.status isEqualToString:@"canceled"])
        cell.detailTextLabel.text = @"已撤销";
    else
        cell.detailTextLabel.text = @"已确定";
    
    
    // update text color according to reading status
    if (order.read ==  YES) {
        titleLabel.textColor = [UIColor grayColor];
        timeLabel.textColor = [UIColor grayColor];
        userLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *day = [self.days objectAtIndex:indexPath.section];
    NSArray *orders = [self.sortedOrders objectForKey:day];
    OrderDetailModel *order = [orders objectAtIndex:indexPath.row];
    [self.readdb save:order.order_id];
    
    if ([order.order_type isEqualToString:kOrderTypeBook]) {
        [self performSegueWithIdentifier:@"show_order_detail_book" sender:self];
    } else if ([order.order_type isEqualToString:kOrderTypeBidding]) {
        if ([order.order_service_type isEqualToString:kServiceType_CarMaintenance])
            [self performSegueWithIdentifier:@"show_order_detail_maintenance" sender:self];
        if ([order.order_service_type isEqualToString:kServiceType_CarFault])
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
    
    UIViewController *controller = segue.destinationViewController;
    controller.hidesBottomBarWhenPushed = YES;
    if ([segue.destinationViewController respondsToSelector:@selector(setOrder:)]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *day = [self.days objectAtIndex:indexPath.section];
        NSArray *orders = [self.sortedOrders objectForKey:day];
        OrderDetailModel *order = [orders objectAtIndex:indexPath.row];
        [segue.destinationViewController setValue:order forKey:@"order"];
        return;
    }
    
}

- (void)orderDaysViewClicked:(id)sender {
    UIButton *button = sender;
    
    NSString *day = [self.days objectAtIndex:button.tag];
    BOOL opened = [[self.dayGrouped objectForKey:day] boolValue];
    [self.dayGrouped setObject:[NSNumber numberWithBool:!opened] forKey:day];
    
    [self.tableView reloadData];
}

-(void)loadMoreOrder:(id)sender {
    [self loadMyOrders];
}



- (void)loadMyOrders {
    SellerModel *seller = [SellerModel sharedClient];
    
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[OrderDetailModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    NSDictionary *params = @{@"role":@"seller", @"seller_id":seller.seller_id, @"offset":[NSNumber numberWithInteger:self.offset], @"num":[NSNumber numberWithInteger:10], @"scope":@"seller"};
    __block MyOrderListViewController *blockself = self;
    [RCar GET:rcar_api_seller_order_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            SellerModel *seller = [SellerModel sharedClient];
            for (OrderDetailModel *order in dataModel.data) {
                order.id = order.order_id; // for read model;
                if (![order.order_id isEqualToString:@""] && ![order.order_type isEqualToString:@""])
                    [seller.orders addObject:order];
            }
            [blockself makeOrderList:seller.orders];
            [blockself.readdb isExistById:seller.orders];
            [blockself.tableView reloadData];
            blockself.offset += seller.orders.count;
            
            blockself.hasMore = (dataModel.data.count == 10);
            [blockself.tableView reloadData];
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
