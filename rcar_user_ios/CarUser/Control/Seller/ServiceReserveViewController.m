//
//  ServiceReserveViewController.m
//  CarUser
//
//  Created by huozj on 2/2/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "ServiceReserveViewController.h"
#import "SellerServiceModel.h"
#import "PickerView.h"
#import "OverlapView.h"
#import "CarInfoModel.h"
#import "UserModel.h"
#import "CarListViewController.h"
#import "LoginViewController.h"
#import "OrderDetailModel.h"

#define TAG_RESERVE_TIME 11
#define TAG_CAR_INFO 12
#define TAG_TELEPHONE 13

typedef enum {
    SECTION_SERVICE_LIST,
    SECTION_ORDER_INFO,
    SECTION_MAX
}SECTION_TYPE;

@interface ServiceReserveViewController () <PickerViewDelegate, OverlapViewDelegate, CarSelectDelegate, MxAlertViewDelegate, LoginViewDelegate>

@end

@implementation ServiceReserveViewController {
    NSString *_reserveTime;
    NSString *_carPlatenumber;
}

@synthesize serviceList;
@synthesize seller;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    self.navigationItem.title = @"提交订单";
    
    
    OverlapView *overlap = [[OverlapView alloc] initWithDelegate:self];
    [self.view addSubview:overlap];
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return SECTION_MAX;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == SECTION_SERVICE_LIST) return serviceList.count;
    else return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == SECTION_ORDER_INFO) return 40.f;
    else return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = nil;
    if (section == SECTION_ORDER_INFO) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 35.f)];
        UIButton *button = [[UIButton alloc]initWithFrame:view.frame];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHex:@"2480FF"];
        [button addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = [self tableView:self.tableView heightForHeaderInSection:section];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    titleView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    [self.view addSubview:titleView];
    
    
    if (section == SECTION_SERVICE_LIST) {
        // totla
        double totalPrice = 0;
        for (int i = 0; i <self. serviceList.count; i++) {
            SellerServiceModel *serviceModel = [self.serviceList objectAtIndex:i];
            totalPrice += [serviceModel.price doubleValue];
        }
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 20,height)];
        textLabel.text = [NSString stringWithFormat:@"您选择了%lu项服务, 总价%.1f元", self.serviceList.count, totalPrice];
        textLabel.font = [UIFont systemFontOfSize:15.f];
        textLabel.contentMode = UIControlContentVerticalAlignmentCenter;
        [titleView addSubview:textLabel];
    } else {
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 20,height)];
        textLabel.text = @"其他情报";
        textLabel.font = [UIFont systemFontOfSize:15.f];
        textLabel.contentMode = UIControlContentVerticalAlignmentCenter;
        [titleView addSubview:textLabel];
    }
    return titleView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"ServiceReserveCell";
    
    if (indexPath.section == SECTION_SERVICE_LIST) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
        
        SellerServiceModel *serviceModel = [serviceList objectAtIndex:indexPath.row];
        cell.textLabel.text = serviceModel.title;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@", serviceModel.price];
        return cell;
        
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
        
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"设定预约时间:";
            cell.detailTextLabel.text = _reserveTime;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"选择车辆信息:";
            UserModel *user = [UserModel sharedClient];
            if (!user.isLogin)
                cell.detailTextLabel.text = @"请首先登陆";
            else if (_carPlatenumber == nil)
                cell.detailTextLabel.text = @"请点击选择车辆";
            else
                cell.detailTextLabel.text = _carPlatenumber;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"手机号码:";
            UserModel *user = [UserModel sharedClient];
            if ([user isLogin])
                cell.detailTextLabel.text = user.user_id;
            else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = @"请首先登陆";
            }
          
        } else {}
        return cell;
    }
}




enum {
    AlertReasonLogin = 0x400,
};

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == SECTION_ORDER_INFO && indexPath.row == 0) {
        // reserve time cell
        NSDate *date = [[NSDate alloc]init];
        PickerView *picker = [[PickerView alloc]initDatePickWithDate:date datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
        picker.delegate = self;
        [picker setToolbarTintColor:[UIColor colorWithHex:@"2480ff"]];
        [picker setTintColor:[UIColor whiteColor]];
        [picker show];
        
    } else if (indexPath.section == SECTION_ORDER_INFO && indexPath.row == 1) {
        UserModel *user = [UserModel sharedClient];
        if (user.isLogin == false) {
            MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"用户未登录，请先登录" delegate:self cancelButtonTitle:@"登录" otherButtonTitles:@"取消", nil];
            alert.tag = indexPath.row;
            [alert show:self];
            return;
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CarInfo" bundle:nil];
        CarListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CarList"];
        controller.delegate = self;
        controller.mode = CarInfoViewModeSelection;
        [self.navigationController pushViewController:controller animated:YES];
        
        
    } else if (indexPath.section == SECTION_ORDER_INFO && indexPath.row == 2) {
        UserModel *user = [UserModel sharedClient];
        if (user.isLogin == false) {
            MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"用户未登录，请先登录" delegate:self cancelButtonTitle:@"登录" otherButtonTitles:@"取消", nil];
            alert.tag = indexPath.row;
            [alert show:self];
            return;
        }
    } else {}
}

/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
*/

#pragma mark - CarSelectDelegate

- (void)carSelected:(CarInfoModel *)carInfo index:(NSInteger)index{
    _carPlatenumber = carInfo.platenumber;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    cell.detailTextLabel.text = carInfo.platenumber;
    [self.tableView reloadData];
}

#pragma mark - PickerViewDelegate
-(void)pickerViewDone:(PickerView *)pickView result:(NSString *)result {
    
    // result = "2015-02-04 03:45:31 +0000"
    NSArray *array=[result componentsSeparatedByString:@"+"];
    _reserveTime = [array objectAtIndex:0];
    _reserveTime = [_reserveTime substringToIndex:16];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.detailTextLabel.text = _reserveTime;
    [self.tableView reloadData];
}

#pragma mark - OverlapViewDelegate

- (void) onTouchBegan:(CGPoint)point withEvent:(UIEvent *)event {
    UITextField *teleField = (UITextField *)[self.tableView viewWithTag:TAG_TELEPHONE];
    [teleField becomeFirstResponder];
    if ([teleField isFirstResponder]) {
        [teleField resignFirstResponder];
    }
}

#pragma mark - MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        LoginViewController *controller = [LoginViewController initWithDelegate:self tag:alertView.tag];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
}

#pragma mark - LoginViewControllerDelegate
- (void)onLoginSuccessed:(NSInteger)tag {
    
    if (tag == 2) { // phone
        UserModel *user = [UserModel sharedClient];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        cell.detailTextLabel.text = user.user_id;
        [self.tableView reloadData];
    } else { // car info
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CarInfo" bundle:nil];
        CarListViewController *controler = [storyboard instantiateViewControllerWithIdentifier:@"CarList"];
        controler.delegate = self;
        controler.mode = CarInfoViewModeSelection;
        [self.navigationController pushViewController:controler animated:YES];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)submitBtnClicked:(id)sender {
    UserModel *userModel = [UserModel sharedClient];
    
    if (_reserveTime == nil || [_reserveTime isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有设定预约时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    if (cell.detailTextLabel.text == nil || [cell.detailTextLabel.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有设定车辆信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
    NSMutableArray *services = [[NSMutableArray alloc]init];
    for (SellerServiceModel *service in self.serviceList) {
        [services addObject:service.service_id];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"role":@"user", @"user_id":userModel.user_id, @"order_type":@"books", @"target_seller":@[self.seller.seller_id], @"date_time":_reserveTime, @"service_list":services}];
    
    __block ServiceReserveViewController *blockself = self;
    [RCar POST:rcar_api_user_order modelClass:nil config:nil params:params success:^(NSDictionary *dataModel) {
        NSString *result = [dataModel valueForKey:@"api_result"];
        if (result.intValue == APIE_OK) {
            [blockself addLocalOrder:[dataModel valueForKey:@"order_id"]];
            [blockself.navigationController popToRootViewControllerAnimated:YES];
        
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

- (void)addLocalOrder:(NSString *)order_id {
    if (order_id != nil && ![order_id isEqualToString:@""]) {
        OrderDetailModel *order = [[OrderDetailModel alloc]init];
        order.order_id = order_id;
        order.order_type = kOrderTypeBook;
        order.order_service_type = kOrderTypeBook;
        order.date_time = _reserveTime;
        order.platenumber = _carPlatenumber;
        order.detail = [[NSMutableDictionary alloc]init];
        NSMutableArray *services = [[NSMutableArray alloc]init];
        
        for (SellerServiceModel *item in self.serviceList) {
            NSMutableDictionary *service = [[NSMutableDictionary alloc]init];
            [service setValue:item.title forKey:@"title"];
            [service setValue:item.price forKey:@"price"];
            [service setValue:item.service_id forKey:@"service_id"];
            [service setValue:item.type forKey:@"service_type"];
            [services addObject:service];
        }
        [order.detail setValue:services forKey:@"services"];
        
        UserModel *user = [UserModel sharedClient];
        [user.orders addObject:order];
    }
}

@end
