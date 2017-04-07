//
//  CarListViewController.m
//  CarUser
//
//  Created by huozj on 1/19/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "CarListViewController.h"
#import "CarModel.h"
#import "CarAddViewController.h"
#import "DataArrayModel.h"
#import "CarKindViewController.h"
#import "UserModel.h"


#define CarNumMax 10

@interface CarListViewController()<CarAddViewDelegae, MxAlertViewDelegate>
@end

@implementation CarListViewController {
    UserModel *_user;
}

@synthesize mode;
@synthesize model;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"所有车辆";
    self.hidesBottomBarWhenPushed = YES;
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addCar:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _user = [UserModel sharedClient];
    if (_user.cars.count == 0)
        [self loadCarList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCar:(id)sender {
    if (_user.cars.count < CarNumMax) {
        [self performSegueWithIdentifier:@"car_info_add" sender:self];
    } else {
        MxAlertView *loginAlertView = [[MxAlertView alloc] initWithTitle:@"提示" message:@"车辆已达到最大数。" delegate:self cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [loginAlertView show:self];
    }
}

- (void)delBtnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"是否要删除本车辆"
                                                  delegate:self cancelButtonTitle:@"删除"
                                         otherButtonTitles:@"取消", nil];
    alert.tag = button.tag;
    [alert show:self];
    return;

}

- (void)editBtnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    CarInfoModel *carinfo = [_user.cars objectAtIndex:button.tag];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CarInfo" bundle:nil];
    CarKindViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CarAddViewController"];
    [controller setValue:carinfo forKey:@"model"];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)selectBtnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if (self.delegate != nil) {
        [self.delegate carSelected:[_user.cars objectAtIndex:button.tag] index:button.tag];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadCarList {
    
    //[activityView startAnimating];
    UserModel *userModel = [UserModel sharedClient];
    
    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[CarInfoModel class] forAttribute:@"data" onClass:[DataArrayModel class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addArrayMapper:mapper];
    
    NSDictionary *params = @{@"role":@"user",
                             @"user_id":userModel.user_id};
    [RCar GET:rcar_api_user_car_list modelClass:@"DataArrayModel" config:config params:params success:^(DataArrayModel *result) {
        //[activityView stopAnimating];
        if (result.api_result == APIE_OK) {
            UserModel *user = [UserModel sharedClient];
            [user.cars addObjectsFromArray:result.data];
            [self.tableView reloadData];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    }failure:^(NSString *errorStr) {
        //[activityView stopAnimating];
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
    
}

- (void)delCarInfo:(CarInfoModel *)carInfo {
    
//    [activityView startAnimating];
    UserModel *userModel = [UserModel sharedClient];
    NSDictionary *params = @{@"role":@"user",
                             @"user_id":userModel.user_id,
                             @"platenumber":carInfo.platenumber};
    [RCar DELETE:rcar_api_user_car modelClass:@"APIResponseModel" config:nil params:params success:^(APIResponseModel *result) {
        //[activityView stopAnimating];
        if (result.api_result == APIE_OK) {
            UserModel *user = [UserModel sharedClient];
            [user.cars removeObject:carInfo];
            [self.tableView reloadData];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    }failure:^(NSString *errorStr) {
        //[activityView stopAnimating];
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
    
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return _user.cars.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = [[NSString alloc]initWithFormat:@"第%lu辆车", section + 1];
    CGRect frame = [tableView rectForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc]initWithFrame:frame];
    //headerView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    // title label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 30)];
    label.text = title; ;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:17.f];
    label.textAlignment = NSTextAlignmentLeft;
    label.contentMode = UIControlContentVerticalAlignmentCenter;
    [headerView addSubview:label];

    // delete button
    UIButton *delButton = [[UIButton alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width - 40, 0, 20, 30)];
    [delButton setImage:[UIImage imageNamed:@"bus"] forState:UIControlStateNormal];
    [delButton addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    delButton.tag = section;
    delButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [headerView addSubview:delButton];
    
    // edit button
    // delete button
    UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width - 70, 0, 20, 30)];
    [editButton setImage:[UIImage imageNamed:@"bus"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    editButton.tag = section;
    editButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [headerView addSubview:editButton];
    
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"CarListTableViewCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    
    NSString *prefix;
    CarInfoModel *info = [_user.cars objectAtIndex:indexPath.section];
    switch (indexPath.row) {
        case 0:
            prefix = @"车辆型号： ";
            cell.textLabel.text = [prefix stringByAppendingString:info.brand];
            break;
        case 1:
            prefix = @"车牌号码： ";
            cell.textLabel.text = [prefix stringByAppendingString:info.platenumber];
            break;
        case 2:
            prefix = @"出厂日期： ";
            cell.textLabel.text = [prefix stringByAppendingString:info.buy_date];
            break;
        case 3:
            prefix = @"行驶里程： ";
            cell.textLabel.text = [prefix stringByAppendingString:info.miles];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mode == CarInfoViewModeSelection) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.delegate != nil) {
            [self.delegate carSelected:[_user.cars objectAtIndex:indexPath.section] index:indexPath.section];
        }
    }
}

#pragma mark - MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        CarInfoModel *carinfo = [_user.cars objectAtIndex:alertView.tag];
        [self delCarInfo:carinfo];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *controller = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"car_info_add"]) {
        [controller setValue:self forKey:@"delegate"];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath != nil) {
            CarInfoModel *info = [_user.cars objectAtIndex:indexPath.row];
            [controller setValue:info forKey:@"model"];
        }
     
    }
}

#pragma mark -CarAddViewDelegate
- (void)carAddViewCompleted:(CarInfoModel *)car {
    int i = 0;
    for (; i < _user.cars.count; i++) {
        CarInfoModel *info = [_user.cars objectAtIndex:i];
        if (info.platenumber == self.model.platenumber) {
            [_user.cars replaceObjectAtIndex:i withObject:car];
            break;
        }
    }
    if (i == _user.cars.count) {
        [_user.cars addObject:car];
    }
    
    [self.tableView reloadData];
}

@end
