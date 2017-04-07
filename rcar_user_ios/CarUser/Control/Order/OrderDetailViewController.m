//
//  OrderDetailViewController.m
//  CarUser
//
//  Created by jenson.zuo on 5/8/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailModel.h"
#import "DataArrayModel.h"
#import "SellerServiceModel.h"
#import "SSTextView.h"
#import "SellerInfoViewController.h"


@interface OrderDetailViewController () <MxAlertViewDelegate>
@end

@implementation OrderDetailViewController
@synthesize order_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"订单详细";
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self getOrderStatus];
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

- (void)loadOrderDetail {
    
    UserModel *user = [UserModel sharedClient];
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[SellerServiceModel class] forAttribute:@"service_list" onClass:[OrderDetailModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    
    NSDictionary *params = @{@"role":@"user", @"user_id":user.user_id, @"order_id":self.order_id};
    __block OrderDetailViewController *blockself = self;
    
    [RCar GET:rcar_api_user_order modelClass:@"OrderDetailModel" config:config params:params success:^(OrderDetailModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            blockself.order = dataModel;
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

- (void) cancelBtnClicked:(id)sender {
    
    UserModel *user = [UserModel sharedClient];
    
    NSDictionary *params = @{@"role":@"user", @"user_id":user.user_id, @"order_id":self.order_id, @"status":@"yes"};
    __block OrderDetailViewController *blockself = self;
    
    [RCar PUT:rcar_api_user_order modelClass:@"APIResponseModel"
               config:nil params:params success:^(APIResponseModel *dataModel) {
        if (dataModel.api_result == APIE_OK) {
            [blockself.navigationController popViewControllerAnimated:YES];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil
                                                           message:@"服务器通信错误"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
            [alert show:self];
        }
        
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
    }];
}

- (void) delBtnClicked:(id)sender {
    
    UserModel *user = [UserModel sharedClient];
    
    NSDictionary *params = @{@"role":@"user", @"user_id":user.user_id, @"order_id":self.order_id};
    __block OrderDetailViewController *blockself = self;
    
    [RCar DELETE:rcar_api_user_order modelClass:@"APIResponseModel"
               config:nil params:params success:^(APIResponseModel *result) {
        if (result.api_result == APIE_OK) {
            [blockself.navigationController popViewControllerAnimated:YES];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
        }
        
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不给力,请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
    }];
}

- (void)getOrderStatus{
    UserModel *user = [UserModel sharedClient];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary: @{@"role":@"user", @"user_id":user.user_id, @"order_id":self.order.order_id, @"status":@"only"}];
    
    __block OrderDetailViewController *blockself = self;
    [RCar GET:rcar_api_user_order modelClass:nil config:nil  params:params success:^(NSDictionary *reply) {
        if ([[reply objectForKey:@"api_result"] integerValue] == APIE_OK) {
            blockself.order.status = [reply objectForKey:@"order_status"];
            [blockself.tableView reloadData];
        }
    } failure:^(NSString *errorStr) {
    }];
}


@end
