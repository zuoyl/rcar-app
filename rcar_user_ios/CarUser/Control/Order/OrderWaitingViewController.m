//
//  FaultWaitingViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 25/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "OrderWaitingViewController.h"
#import "UserModel.h"
#import "FaultReportResultCell.h"
#import "OrderStatusModel.h"
#import "DataArrayModel.h"
#import "SellerInfoViewController.h"
#import "NotifyCenterModel.h"

#define FaultWaitResultMaxNumber (10)

@interface OrderWaitingViewController () <MxAlertViewDelegate>

@end


@implementation OrderWaitingViewController {
    NSMutableArray *_results;
    NSTimer *_timer;
}
@synthesize mapView;
@synthesize cancelBtn;
@synthesize tableView;
@synthesize order_id;
@synthesize order_type;
@synthesize rootController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // create baidu map
    self.navigationItem.title = @"联络等待";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(toHomeBtnClicked:)];
    [leftItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    _results = [[NSMutableArray alloc]initWithCapacity:FaultWaitResultMaxNumber];
    
    // create map view
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.mapView setShowsUserLocation:YES];//开启定位功能
    
    // create table view
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 220, self.view.frame.size.width, self.view.frame.size.height - 260)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    
    // create cancel button
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    self.cancelBtn.backgroundColor = [UIColor colorWithHex:@"2480ff"];
    [self.cancelBtn setTitle:@"撤销已提交订单" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClcked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    // create help button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"帮助" style:UIBarButtonItemStylePlain target:self action:@selector(helpWaittingBtnClicked:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // register kvo controller
    NotifyCenterModel *notifyCenter = [NotifyCenterModel sharedClient];
    __block OrderWaitingViewController *blockself = self;
    
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:notifyCenter keyPath:@"orders" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        // get new data by change[NSKeyValueChangeNewKey];
        [blockself getOrderStatus];
        
    }];
    
    [self getOrderStatus];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
    self.mapView.delegate = nil;
    self.mapView = nil;
}

- (void)helpWaittingBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"fault_show_help" sender:self];
}


- (void)timerFired:(id)sender {
    [self getOrderStatus];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)toHomeBtnClicked:(id)sender {
    if (self.rootController)
        [self.navigationController popToViewController:self.rootController animated:YES];
    else
        [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _results.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = [self tableView:self.tableView heightForHeaderInSection:section];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    titleView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    [self.view addSubview:titleView];
    
    
    NSString *title;
    if (_results.count > 0)
        title = [NSString stringWithFormat:@"已经有 %lu 个商家反馈您的订单...)", (unsigned long)_results.count ];
    else
        title = @"等待商家反馈中";
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 20,height)];
    textLabel.text = title;
    textLabel.font = [UIFont systemFontOfSize:15.f];
    textLabel.contentMode = UIControlContentVerticalAlignmentCenter;
    [titleView addSubview:textLabel];

    return titleView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *faultReplyCellIdentifier = @"FaultReportResultCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:faultReplyCellIdentifier];
    if (cell == nil) {
        cell = [[FaultReportResultCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:faultReplyCellIdentifier];
    } else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    OrderStatusModel *order = [_results objectAtIndex:indexPath.row];
    
    // image
    cell.imageView.frame = CGRectMake(10, 10, 40, 40);
    if (order.images != nil && order.images.count > 0) {
        NSString *url = [[RCar imageServer] stringByAppendingString:order.images[0]];
        url = [url stringByAppendingString:@"?target=user&size=32x32&thumbnail=yes"];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"adv_banner"] options:SDWebImageOption];
    } else {
        [cell.imageView setImage:[UIImage imageNamed:@"train"]];
    }
    // index label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 10, 10)];
    label.backgroundColor = [UIColor blueColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:10.f];
    const unichar indexChar = 'A' + indexPath.row;
    label.text = [[NSString alloc]initWithCharacters:&indexChar length:1];
    [cell.contentView addSubview:label];
    
    NSString *content = [@"费用:" stringByAppendingString:order.cost];
    content = [content stringByAppendingString:@"元 "];
    content = [content stringByAppendingString:@"工时:"];
    content = [content stringByAppendingString:order.time];
    content = [content stringByAppendingString:@"小时 "];
    
    // price lable
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, self.view.frame.size.width - 60 - 60, 20)];
    nameLabel.text = order.name;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:13.f];
    [cell.contentView addSubview:nameLabel];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, self.view.frame.size.width - 60 - 60, 20)];
    detailLabel.text = content;
    detailLabel.textColor = [UIColor blackColor];
    detailLabel.font = [UIFont systemFontOfSize:13.f];
    [cell.contentView addSubview:detailLabel];
    
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 40, self.view.frame.size.width - 60 - 60, 20)];
    infoLabel.text = order.address;
    infoLabel.text = [infoLabel.text stringByAppendingString:@"  距离:"];
    infoLabel.text = [infoLabel.text stringByAppendingString:order.distance.stringValue];
    infoLabel.text = [infoLabel.text stringByAppendingString:@"公里"];
    
    
    infoLabel.textColor = [UIColor blackColor];
    infoLabel.font = [UIFont systemFontOfSize:12.f];
    [cell.contentView addSubview:infoLabel];
    
    // add agree button
    UIButton *agreeBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 20, 40, 20)];
    [agreeBtn setTitle:@"接受" forState:UIControlStateNormal];
    [agreeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [agreeBtn addTarget:self action:@selector(agreeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:agreeBtn];
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_results.count > 0) {
        OrderStatusModel *order = [_results objectAtIndex:indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
        SellerInfoViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"SellerInfoViewController"];
        viewController.sellerId = order.seller_id;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
enum {
    AlertReasonServer,
    AlertReasonNetwork,
};

- (void)agreeBtnClicked:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    OrderStatusModel *order = [_results objectAtIndex:indexPath.row];
    
    UserModel *user = [UserModel sharedClient];
    NSDictionary *params = @{@"role":@"user", @"user_id":user.user_id, @"order_id":self.self.order_id, @"status":@"agree", @"seller_id":order.seller_id};
    
    __block OrderWaitingViewController *blockself = self;
    [RCar PUT:rcar_api_user_order modelClass:nil config:nil params:params success:^(APIResponseModel *result) {
        if (result.api_result == APIE_OK) {
            [_timer invalidate];
            [blockself.navigationController popToRootViewControllerAnimated:YES];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = AlertReasonServer;
            [alert show:self];
            return;
        }
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不能连接,请检查网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = AlertReasonNetwork;
        [alert show:self];
        return;
    }];
}


- (void)cancelBtnClcked:(id)sender {
    [_timer invalidate];
    UserModel *user = [UserModel sharedClient];
    __block OrderWaitingViewController *blockself = self;
    if (self.order_id != nil && ![self.order_id isEqualToString:@""]) {
        // cancel the fault publication
        NSDictionary *params = @{@"role":@"user", @"user_id":user.user_id, @"order_id":self.order_id, @"status":@"canceled"};
        [RCar PUT:rcar_api_user_order modelClass:@"APIResponseModel" config:nil params:params success:^(APIResponseModel *result) {
            if (result.api_result == APIE_OK) {
                if (blockself.rootController)
                    [blockself.navigationController popToViewController:blockself.rootController animated:YES];
                else
                    [blockself.navigationController popToRootViewControllerAnimated:YES];
            } else {
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = AlertReasonServer;
                [alert show:self];
                return;
            }
        } failure:^(NSString *errorStr) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不能连接,请检查网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = AlertReasonNetwork;
            [alert show:self];
            return;
        }];
    }
   
}

#pragma mark - MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertReasonNetwork || alertView.tag == AlertReasonServer) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
}
              
- (void)getOrderStatus {
    UserModel *user = [UserModel sharedClient];
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[OrderStatusModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    NSDictionary *params = @{@"role":@"user", @"order_id":self.order_id, @"user_id":user.user_id, @"num":[NSNumber numberWithInt:10], @"offset":[NSNumber numberWithInteger:_results.count], @"status":@"yes"};
    
    __block OrderWaitingViewController *blockself = self;
    [RCar GET:rcar_api_user_order_replies modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            if (dataModel.data.count > 0) {
                [_results addObjectsFromArray:dataModel.data];
                [blockself.tableView reloadData];
            }
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
        
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不能连接,请检查网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }];
    
}



@end
