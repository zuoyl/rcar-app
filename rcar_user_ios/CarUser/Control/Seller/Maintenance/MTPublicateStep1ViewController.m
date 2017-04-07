//
//  MaintenancePublicateStep1ViewController.m
//  CarUser
//
//  Created by huozj on 3/2/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "MTPublicateStep1ViewController.h"
#import "MTPublicateStep2ViewController.h"
#import "ServicePublicateModel.h"
#import "CheckBoxView.h"
#import "RadioButton.h"
#import "PickerView.h"
#import "CarListViewController.h"
#import "LoginViewController.h"
#import "MxLabelsMatrix.h"
#import "DataArrayModel.h"

enum {
    AlertReasonLogin = 0x400,
};


@interface MTPublicateStep1ViewController ()<CheckBoxViewDelegate, PickerViewDelegate, LoginViewDelegate, MxAlertViewDelegate, CarSelectDelegate, UITextFieldDelegate>

@end


@implementation MTPublicateStep1ViewController {
    NSString *_maintenanceType;
    ServicePublicateModel *_publicateModel;
    NSMutableArray *_mileageItems;
    NSMutableArray *_mileageSelectedItems;
    NSMutableArray *_userItems;
    NSMutableArray *_userSelectedItems;
    MxLabelsMatrix *_table1;
    MxLabelsMatrix *_table2;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"预约保养(1/2)";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    _maintenanceType = @"mileage";
    _publicateModel = [[ServicePublicateModel alloc]init];
    _mileageItems = [[NSMutableArray alloc]init];
    _mileageSelectedItems = [[NSMutableArray alloc]init];
    _userItems = [[NSMutableArray alloc]init];
    _userSelectedItems = [[NSMutableArray alloc]init];
    
    NSArray *widths = @[@100, @(self.view.frame.size.width - 160), @60];
    _table1 = [[MxLabelsMatrix alloc]initWithFrame:CGRectZero andColumnsWidths:widths];
    _table2 = [[MxLabelsMatrix alloc]initWithFrame:CGRectZero andColumnsWidths:widths];
    
    [self initMaintenanceData];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    //[super viewWillAppear:animated];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CheckBoxViewDelegate
- (void)didSelectedCheckBox:(CheckBoxView *)checkbox checked:(BOOL)checked {
    if (checkbox.group == _table1) {
        NSArray *items = [_mileageItems objectAtIndex:checkbox.tag];
        if (checkbox.selected == YES)
            [_mileageSelectedItems addObject:items[0]];
        else
            [_mileageSelectedItems removeObject:items[0]];
        
    } else if (checkbox.group == _table2) {
        NSArray *items = [_userItems objectAtIndex:checkbox.tag];
        
        if (checkbox.selected == YES)
            [_userSelectedItems addObject:items[0]];
        else
            [_userSelectedItems removeObject:items[0]];
        
    } else {
        if (checkbox.selected == YES)
            _maintenanceType = @"unkown";
        else
            _maintenanceType = @"mileage";
        
    }
}

- (void)nextBtnClicked:(id)sender {
    if (_publicateModel.time == nil) {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"没有设定预约时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    if (_publicateModel.platenumber == nil) {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"没有设定车辆情报" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
    if (_maintenanceType == nil || [_maintenanceType isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"没有选择保养类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    UITextField *textField = (UITextField *)[self.tableView viewWithTag:0x500];
    _publicateModel.mileage = textField.text;
    
    if ([_maintenanceType isEqualToString:@"mileage"] &&
        (_publicateModel.mileage == nil || [_publicateModel.mileage isEqualToString:@""]) ) {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"选择按里程保养时,请填写车辆里程数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    if ([_maintenanceType isEqualToString:@"mileage"] && _userSelectedItems.count == 0 && _mileageSelectedItems.count == 0) {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"没有选择保养项目" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
        
    }
    if (_publicateModel.items == nil)
        _publicateModel.items = [[NSMutableDictionary alloc]init];
    
    [_publicateModel.items setValue:_maintenanceType forKey:@"type"];
    [_publicateModel.items setValue:_userSelectedItems forKey:@"user_items"];
    [_publicateModel.items setValue:_mileageSelectedItems forKey:@"mileage_items"];
    
    if ([_maintenanceType isEqualToString:@"mileage"])
        [_publicateModel.items setValue:_publicateModel.mileage forKey:@"mileage"];
    
    
    [self performSegueWithIdentifier:@"maintenance_next_step2" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) return 3;
    else if (section == 1)return 1;
    else if (section == 2)return 1;
    else if (section == 3)return 0;
    
    else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) return _table1.frame.size.height;
    else if (indexPath.section == 2) return _table2.frame.size.height;
    else return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) return 40.f;
    else return 0.5f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 0.f;
    else return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray * titles = @[@"", @"推荐保养项目", @"其他保养项目", @"我不知道什么项目,到店检查"];
    UIView *view = nil;
    if (section > 0) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30.f)];
        view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, self.view.frame.size.width - 40, 30.f)];
        label.font = [UIFont systemFontOfSize:15.f];
        label.text = [titles objectAtIndex:section];
        
        if (section == 3) {
            CheckBoxView *checkBox = [[CheckBoxView alloc]initWithDelegateAndGroup:self group:nil];
            [checkBox setFrame:CGRectMake(self.tableView.frame.size.width - 35, 5, 40, 20)];
            [view addSubview:checkBox];
        }
        [view addSubview:label];
        
        if (section != 3) {
            UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 5, 30)];
            tagLabel.backgroundColor = [UIColor colorWithHex:@"2480ff"];
            [view addSubview:tagLabel];
        }
    }
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 3) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.f)];
        UIButton *button = [[UIButton alloc]initWithFrame:view.frame];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"下一步" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHex:@"2480FF"];
        [button addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        return view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"maintenanceCell";
    
    //UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //if (cell == nil)
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // create radio button and check box
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"预约时间";
            cell.detailTextLabel.text = _publicateModel.time;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"车辆信息";
            cell.detailTextLabel.text = _publicateModel.platenumber;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        } else if (indexPath.row == 2) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"车辆行程公里数";
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 0 , 90, 40.f)];
            textField.contentMode = UIControlContentVerticalAlignmentCenter;
            textField.placeholder = @"公里数";
            textField.text = _publicateModel.car.miles;
            textField.tag = 0x500;
            textField.font = [UIFont systemFontOfSize:15.f];
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            textField.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:textField];
            
            UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
            [topView setBarStyle:UIBarStyleDefault];
            topView.tintColor = [UIColor colorWithHex:@"2480ff"];
    
            UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard:)];
            [leftItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHex:@"2480ff"]}
                                    forState:UIControlStateNormal];
            
            UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            
            UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"确定"
                                                                           style:UIBarButtonItemStyleDone
                                                                          target:self
                                                                          action:@selector(dismissKeyboard:)];
            [doneButton setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHex:@"2480ff"]} forState:UIControlStateNormal];
            
            NSArray * buttonsArray = [NSArray arrayWithObjects:leftItem,btnSpace,doneButton,nil];
            [topView setItems:buttonsArray];
            [textField setInputAccessoryView:topView];
        }
    } else if (indexPath.section == 3) {
        return nil;
    } else if (indexPath.section == 1) { // milage maintenance
        if (_mileageItems.count > 0) {
            cell.textLabel.text = nil;
            
            CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
            [_table1 setFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
            for (NSArray * items in _mileageItems) {
                [_table1 addRecord:items];
            }
            [cell.contentView addSubview:_table1];
        } else {
            cell.textLabel.text = @"无推荐保养项目";
        }
        
    } else  if (indexPath.section == 2) { // user selection maintenance
        if (_userItems.count > 0) {
            cell.textLabel.text = nil;
            CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
            [_table2 setFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
            for (NSArray * items in _userItems) {
                [_table2 addRecord:items];
            }
            [cell.contentView addSubview:_table2];
        } else {
            cell.textLabel.text = @"无其他保养项目";
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSDate *date = [[NSDate alloc]init];
        PickerView *picker = [[PickerView alloc]initDatePickWithDate:date datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
        picker.delegate = self;
        [picker setToolbarTintColor:[UIColor colorWithHex:@"2480ff"]];
        [picker show];
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        UserModel *userModel = [UserModel sharedClient];
        if ([userModel isLogin] == false) {
            MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"请登录后取得车辆信息" delegate:self cancelButtonTitle:@"登录" otherButtonTitles:@"取消", nil];
            alert.tag = AlertReasonLogin;
            [alert show:self];
            return;
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CarInfo" bundle:nil];
        CarListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CarList"];
        controller.mode = CarInfoViewModeSelection;
        controller.delegate = self;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }

}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyDone) {
        [self.view endEditing:YES];
    }
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    
}

- (void)dismissKeyboard :(id)sender {
    [[self.view viewWithTag:0x500] endEditing:YES];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *controller = segue.destinationViewController;
    controller.hidesBottomBarWhenPushed = YES;
    if ([controller respondsToSelector:@selector(setModel:)]) {
        [controller setValue:_publicateModel forKey:@"model"];
    }
    if ([controller respondsToSelector:@selector(setDelegate:)]) {
        [controller setValue:self forKey:@"delegate"];
    }
}

#pragma mark - CarSelectDelegate

- (void)carSelected:(CarInfoModel *)carInfo index:(NSInteger)index{
    _publicateModel.car = carInfo;
    _publicateModel.platenumber = carInfo.platenumber;
    
    NSArray *cells = [self.tableView indexPathsForVisibleRows];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[cells objectAtIndex:1]];
    cell.detailTextLabel.text = _publicateModel.platenumber;
    [self.tableView reloadRowsAtIndexPaths:@[cells[1]] withRowAnimation:UITableViewRowAnimationNone];
    
    
    cell = [self.tableView cellForRowAtIndexPath:[cells objectAtIndex:2]];
    UITextField *textField = [cell.contentView viewWithTag:0x500];
    textField.text = carInfo.miles;
    
    if (carInfo.miles != nil)
        [self getMaintenaceInfo:carInfo.miles];
}

#pragma mark - PickerViewDelegate
-(void)pickerViewDone:(PickerView *)pickView result:(NSString *)result {
    NSArray *array=[result componentsSeparatedByString:@"+"];
    _publicateModel.time = [array objectAtIndex:0];
    _publicateModel.time = [_publicateModel.time substringToIndex:16];
    
    
    NSArray *cells = [self.tableView indexPathsForVisibleRows];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[cells objectAtIndex:0]];
    cell.detailTextLabel.text = _publicateModel.time;
    [self.tableView reloadRowsAtIndexPaths:@[cells[0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UIActionSheetDelegate

- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertReasonLogin && buttonIndex == 0) {
        if (_publicateModel == nil || _publicateModel.car == nil) {
            // login viewcontroller
            LoginViewController *controller = [LoginViewController initWithDelegate:self tag:0];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark - LoginViewDelegate
- (void)onLoginSuccessed :(NSInteger)tag{
    if (_publicateModel == nil || _publicateModel.car == nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CarInfo" bundle:nil];
        CarListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CarList"];
        controller.mode = CarInfoViewModeSelection;
        controller.hidesBottomBarWhenPushed = YES;
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
- (void)onLoginFailed :(NSInteger)tag{
    
}


- (void) getMaintenaceInfo:(NSString *)mileage {
    NSDictionary *params = @{@"role":@"user", @"kind": _publicateModel.car.kind, @"brand":_publicateModel.car.brand, @"mileage":[NSNumber numberWithInt:mileage.intValue]};
    __block MTPublicateStep1ViewController *blockself = self;
    [RCar GET:rcar_api_user_car_maintenance_info modelClass:nil config:nil params:params success:^(NSDictionary *dataModel) {
        NSString *result = [dataModel objectForKey:@"api_result"];
        if (result.integerValue == APIE_OK) {
            [blockself handleMaintenanceData:dataModel];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    }failure:^(NSString *errorStr) {
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
}

- (void)handleMaintenanceData:(NSDictionary *)data {
    [_table1 clear];
    [_table2 clear];
    
    NSArray *mitems = [data objectForKey:@"mileage"];
    NSArray *uitems = [data objectForKey:@"user"];
    
    NSMutableArray *childItems = [[NSMutableArray alloc]init];
    
    [_mileageItems removeAllObjects];
    [_mileageItems addObjectsFromArray:@[@[@"保养项目", @"常见问题", @"是否保养"]]];
    for (NSDictionary *it in mitems) {
        NSMutableArray *items = [[NSMutableArray alloc]init];
        [items addObject:[it objectForKey:@"item"]];
        [childItems addObject:[it objectForKey:@"item"]];
        
        [items addObject:[it objectForKey:@"desc"]];
        CheckBoxView *checkBox = [[CheckBoxView alloc]initWithDelegateAndGroup:self group:_table1];
        checkBox.tag = [mitems indexOfObject:it];
        [items addObject:checkBox];
        [_mileageItems addObject:items];
    }
    
    [_userItems removeAllObjects];
    [_userItems addObjectsFromArray:@[@[@"保养项目", @"常见问题", @"是否保养"]]];
    for (NSString *it in uitems) {
        if ([childItems containsObject:it])
            continue;
        NSMutableArray *items = [[NSMutableArray alloc]init];
        [items addObject:it];
        [items addObject:@"-"];
        CheckBoxView *checkBox = [[CheckBoxView alloc]initWithDelegateAndGroup:self group:_table2];
        checkBox.tag = [uitems indexOfObject:it];
        [items addObject:checkBox];
        [_userItems addObject:items];
    }
    
    [self.tableView reloadData];
}

- (void)initMaintenanceData {
    NSDictionary *defaultDatas = @{
                                   @"mileage": @[ @{@"item":@"轮胎", @"desc":@"-"}],
                                   @"user":@[ @"雨刷", @"空调过滤",  @"机油"]
                                   };
    [self handleMaintenanceData:defaultDatas];
}



@end
