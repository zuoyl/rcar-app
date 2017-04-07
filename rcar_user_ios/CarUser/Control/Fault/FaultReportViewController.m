//
//  FaultViewController.m
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-15.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import "FaultReportViewController.h"
#import "FaultModel.h"
#import "FaultDetailReportViewController.h"
#import "SellerSearchViewController.h"
#import "FaultModel.h"
#import "UserModel.h"
#import "OrderWaitingViewController.h"
#import "PhotoAlbumView.h"
#import "CheckBoxView.h"
#import "CarListViewController.h"
#import "PickerView.h"
#import "LoginViewController.h"
#import "InsetsTextField.h"




@interface FaultReportViewController (SellerSearchDelegate)<FaultDetailViewDelegate, CheckBoxViewDelegate, CarSelectDelegate, PickerViewDelegate, LoginViewDelegate,UITextFieldDelegate,UIActionSheetDelegate, BMKMapViewDelegate, CLLocationManagerDelegate, MxAlertViewDelegate>

@end

@implementation FaultReportViewController {
    FaultModel *_faultModel;
    BMKMapView *_mapView;
    PhotoAlbumView *_photoAlbumView;
    CLLocationManager *_locationMgr;
//    CLLocationCoordinate2D _userCoordinate;
  
}

@synthesize infoTextView;
@synthesize posTextField;


-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"故障报告";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    _faultModel = [[FaultModel alloc] init];
    
    self.infoTextView = [[SSTextView alloc]init];
    self.infoTextView.placeholder = @"请填写车辆故障部位的详细情况";
    self.infoTextView.text = @"";
    self.infoTextView.font = [UIFont systemFontOfSize:15.f];
    self.infoTextView.contentInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    [self.infoTextView setEditable:NO];
    
    self.posTextField = [[UITextField alloc]init];
    self.posTextField.placeholder = @"出现场时,请填写故障地点";
    self.posTextField.font = [UIFont systemFontOfSize:15.f];
    [self.posTextField setEnabled:false];
    
    // create photo album view
    _photoAlbumView = [PhotoAlbumView initWithViewController:self frame:CGRectZero mode:PhotoAlbumMode_Edit];
    _photoAlbumView.maxOfImage = 4;
    
   
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    //[super viewWillAppear:animated];
    [self initLocationManager];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    _mapView = [[BMKMapView alloc]initWithFrame:cell.contentView.frame];
    _mapView.delegate = self;
    [_mapView setShowsUserLocation:YES];//开启定位功能

}

- (void)viewWillDisappear:(BOOL)animated {
    _mapView.delegate = nil;
    _mapView = nil;
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
    UIViewController *controller = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"fault_show_detail"]) {
        [controller setValue:self forKey:@"delegate"];
        return;
    }
    if ([segue.identifier isEqualToString:@"show_target_seller"]) {
        [controller setValue:_faultModel forKey:@"faultModel"];
        return;
    }
}

- (void)didSelectedCheckBox:(CheckBoxView *)checkbox checked:(BOOL)checked {
    _faultModel.touser = checked;
    [self.posTextField setEnabled:checked];
    
}
- (void)carSelected:(CarInfoModel *)carInfo index:(NSInteger)index {
    _faultModel.platenumber = carInfo.platenumber;
    [self.tableView reloadData];
}

enum {
    AlertForCarSelect = 0x400,
    AlertForNext,
};

enum {
    SectionMap,
    SectionInfo,
    SectionImage,
    SectionMax,
};

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SectionMax;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"", @"故障描述", @"故障图片"];
    return titles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == SectionMap) return 3;
    else if (section == SectionInfo) return 4;
    else if (section == SectionImage) return 1;
    else return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 0) return 25.f;
    else return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == SectionImage) return 40.f;
    else return 0.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.f;
    switch (indexPath.section) {
        case SectionMap:
            if (indexPath.row == 0)height = 180.f;
            else height = 40.f;
            break;
            
        case SectionInfo:
            if (indexPath.row == 2) height = 60.f;
            else height = 40.f;
            break;
            
        case SectionImage:
            if (indexPath.row == 0) height = 90.f;
            else height = 40.f;
            break;
            
        default:
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CellIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    cell.backgroundColor = [UIColor whiteColor];
    switch (indexPath.section) {
        case SectionMap:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                [cell.contentView addSubview:_mapView];
            } else  if (indexPath.row == 1){
                cell.textLabel.text = @"是否需要出现场维修";
                CheckBoxView *checkbox = [[CheckBoxView alloc]initWithDelegateAndGroup:self group:nil];
                CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
                [checkbox setFrame:CGRectMake(self.view.frame.size.width - 25, 0, height, height)];
                [cell.contentView addSubview:checkbox];
            } else {
                cell.textLabel.text = @"故障地点";
                [self.posTextField setFrame:CGRectMake(80, 0, cell.frame.size.width - 100, cell.frame.size.height)];
                [cell.contentView addSubview:self.posTextField];
            }
            break;
            
        case SectionInfo:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"选择发生故障的车辆";
                cell.detailTextLabel.text = _faultModel.platenumber;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"选择车辆故障信息";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else if (indexPath.row == 2) {
                [self.infoTextView setFrame:cell.contentView.frame];
                [cell.contentView addSubview:self.infoTextView];
            } else if (indexPath.row == 3) {
                cell.textLabel.text = @"设定预约时间";
                cell.detailTextLabel.text = _faultModel.date_time;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            break;
            
        case SectionImage:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(indexPath.row == 0) {
                [_photoAlbumView setFrame:cell.contentView.frame];
                [cell.contentView addSubview:_photoAlbumView];
            }
            break;
            
        default:
            break;
    }
   // cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 &&  indexPath.row == 0) {
        UserModel *user = [UserModel sharedClient];
        if ([user isLogin]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CarInfo" bundle:nil];
            CarListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CarList"];
            controller.delegate = self;
            controller.mode = CarInfoViewModeSelection;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户未登录,是否立即登录" delegate:self cancelButtonTitle:@"登录" otherButtonTitles:@"取消", nil];
            alert.tag = AlertForCarSelect;
            [alert show:self];
            return;
        }
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        [self performSegueWithIdentifier:@"fault_show_detail" sender:self];
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        NSDate *date = [NSDate date];
        PickerView *picker = [[PickerView alloc]initDatePickWithDate:date datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:YES];
        picker.delegate = self;
        [picker setToolbarTintColor:[UIColor colorWithHex:@"2480ff"]];
        [picker show];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = [self.tableView sectionHeaderHeight];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, height)];
    
    if (section > 0) {
        view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15.f, 0, self.tableView.frame.size.width, height)];
        label.text = [self tableView:self.tableView titleForHeaderInSection:section];
        label.font = [UIFont systemFontOfSize:15.f];
        
        [view addSubview:label];
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = nil;
    if (section == SectionImage) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.f)];
        UIButton *button = [[UIButton alloc]initWithFrame:view.frame];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"选择推送商家" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHex:@"2480FF"];
        [button addTarget:self action:@selector(onNextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    return view;
}

#pragma mark - FaultDetailViewDelegate
- (void)faultItemSelected:(NSArray *)decs {
    if (_faultModel.items == nil) {
        _faultModel.items = [[NSMutableArray alloc]initWithArray:decs];
    } else {
        [_faultModel.items removeAllObjects];
        [_faultModel.items addObjectsFromArray:decs];
    }
    // display the content in sstext view
    NSString *title = self.infoTextView.text;
    title = [title stringByAppendingString:@"¥n"];
    for (NSString *item in decs) {
        if (item != nil && ![item isEqualToString:@""]) {
            title = [title stringByAppendingString:item];
            title = [title stringByAppendingString:@"¥n"];
        }
    }
    self.infoTextView.text = title;
}

- (void) onNextBtnClicked:(id)sender {
    if (_faultModel.platenumber == nil && [_faultModel.platenumber isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"没有选择故障车辆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    if (_faultModel.date_time == nil || [_faultModel.date_time isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"没有选择预约时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    if (_faultModel.platenumber == nil || [_faultModel.platenumber isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"车牌号码没有设定" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    if (_faultModel.touser && [self.posTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"出现场维修时,请填写车辆故障地点" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    if (_photoAlbumView.numberOfImage == 0) {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"没有添加车辆故障照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
        
    }
    
    _faultModel.title = self.infoTextView.text;
    _faultModel.position = self.posTextField.text;
    _faultModel.images = [_photoAlbumView getImageDatasWithJpegCompress:0.5f];;
    
    UserModel *user = [UserModel sharedClient];
    if ([user isLogin] == false) {
        LoginViewController *controller = [LoginViewController initWithDelegate:self tag:AlertForNext];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    [self performSegueWithIdentifier:@"show_target_seller" sender:self];
}

- (void)onLoginSuccessed:(NSInteger)tag {
    if (tag == AlertForNext)
        [self performSegueWithIdentifier:@"show_target_seller" sender:self];
    else if (tag == AlertForCarSelect) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CarInfo" bundle:nil];
        CarListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CarList"];
        controller.delegate = self;
        controller.mode = CarInfoViewModeSelection;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (void)onLoginFailed :(NSInteger)tag{
    NSLog(@"login failed");
}

- (void)initLocationManager {
    // get location
    if ([CLLocationManager locationServicesEnabled]) {
        _locationMgr = [[CLLocationManager alloc] init];
        [_locationMgr setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationMgr.delegate = self;
        _locationMgr.distanceFilter = 1000.0f;
        [_locationMgr startUpdatingLocation];
        //[self.activity startAnimating];
    } else {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:@"警告" message:@"位置服务不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设定", nil];
        [alert show:self];
    }
    
#if 1 // for simulation test
    CLLocation *location = [[CLLocation alloc]initWithLatitude:39.983424 longitude:116.322987];
    [self locationManager:_locationMgr didUpdateLocations:[NSArray arrayWithObject:location]];
#endif
}



#pragma mark - MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertForCarSelect) {
        if (buttonIndex == 0) {
            LoginViewController *controller = [LoginViewController initWithDelegate:self tag:AlertForCarSelect];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
    }
}
#pragma mark - PickerViewDelegate
-(void)pickerViewDone:(PickerView *)pickView result:(NSString *)result {
    NSArray *array=[result componentsSeparatedByString:@"+"];
    _faultModel.date_time = [array objectAtIndex:0];
    _faultModel.date_time = [_faultModel.date_time substringToIndex:16];
    
    [self.tableView reloadData];
    
}

- (void)getCurrentPositon {
    __block FaultReportViewController *blockself = self;
    [RCar callBaiduGeocoder:[_faultModel.location objectForKey:@"lat"] lng:[_faultModel.location objectForKey:@"lng"] success:^(NSMutableDictionary *data) {
        NSNumber *status = [data objectForKey:@"status"];
        if ([status intValue] == 0) {
            NSMutableDictionary *result = [data objectForKey:@"result"];
            NSMutableDictionary *address = [result objectForKey:@"addressComponent"];
            NSString *district = [address objectForKey:@"district"];
            NSString *street = [address objectForKey:@"street"];
            NSString *street_number = [address objectForKey:@"street_number"];
            
            blockself.posTextField.text = [[district stringByAppendingString:street] stringByAppendingString:street_number];
        } else {
            NSLog(@"BaiduGeocoder return error");
        }
    } failure:^(NSString *errorStr) {
        NSLog(@"failt to get fault detail info");
    }];
}




#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //[self.activity stopAnimating];
    CLLocation *location = [locations lastObject];
    NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude] ;
    NSNumber *lng = [NSNumber numberWithDouble:location.coordinate.longitude] ;
    [_locationMgr stopUpdatingLocation];
    _faultModel.location = [[NSMutableDictionary alloc] initWithObjectsAndKeys:lat, @"lat", lng, @"lng", nil];
    
    // 取得当前经纬度对应的名称
    [self getCurrentPositon];
    
    // 设置中心点坐标
    [_mapView setCenterCoordinate:location.coordinate];
    
    // 添加标注
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = location.coordinate;//经纬度
    //item.title = posInput.text;    //标题
    //item.subtitle = @"subtitle";//子标题
    [_mapView addAnnotation:item];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    MxAlertView *alert = [[MxAlertView alloc] initWithTitle:@"警告" message:@"位置服务不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设定", nil];
    [alert show:self];
}

#pragma mark - BMKMapViewDelegate
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
#if 0
    static NSString *AnnotationViewID = @"annotationViewID";
    
    BMKAnnotationView *annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_location.png"]];//气泡框左侧显示的View,可自定义
        
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectButton setFrame:(CGRect){260,0,50,annotationView.frame.size.height}];
        [selectButton setTitle:@"确定" forState:UIControlStateNormal];
        annotationView.rightCalloutAccessoryView =selectButton;//气泡框右侧显示的View 可自定义
        [selectButton setBackgroundColor:[UIColor redColor]];
        [selectButton setShowsTouchWhenHighlighted:YES];
        [selectButton addTarget:self action:@selector(selectPointAnnotation:) forControlEvents:UIControlEventTouchUpInside];
    }
    //以下三行代码用于将自定义视图和标记绑定,一一对应,目的是当点击,右侧自定义视图时,能够知道点击的是那个标记
    //    annotationView.rightCalloutAccessoryView.tag = _cacheAnnotationTag;
    //    [_cacheAnnotationMDic setObject:annotation forKey:[NSNumber numberWithInteger:_cacheAnnotationTag]];
    //    _cacheAnnotationTag++;
    
    //如果是我的位置标注,则允许用户拖动改标注视图,并赋予绿色样式 处于
    if ([annotation.title isEqualToString:@"title"]) {
        ((BMKPinAnnotationView *)annotationView).pinColor = BMKPinAnnotationColorGreen;//标注呈绿色样式
        [annotationView setDraggable:YES];//允许用户拖动
        [annotationView setSelected:YES animated:YES];//让标注处于弹出气泡框的状态
    }else
    {
        ((BMKPinAnnotationView *)annotationView).pinColor = BMKPinAnnotationColorRed;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));//不知道干什么用的
    annotationView.annotation = annotation;//绑定对应的标点经纬度
    annotationView.canShowCallout = TRUE;//允许点击弹出气泡框
    return annotationView;
#else
    static NSString *AnnotationViewID = @"annotationViewID";
    
    BMKAnnotationView *annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    //如果是我的位置标注,则允许用户拖动改标注视图,并赋予绿色样式 处于
    ((BMKPinAnnotationView *)annotationView).pinColor = BMKPinAnnotationColorRed;//标注呈绿色样式
    //annotationView.enabled = NO;
    //[annotationView setDraggable:YES];//允许用户拖动
    //[annotationView setSelected:YES animated:YES];//让标注处于弹出气泡框的状态
    return annotationView;
#endif
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    
}

#pragma mark - SellerSearchDelegate
- (void)sellerSearchComplete:(NSDictionary *)result {
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}


- (void)hideKeyboard:(UITapGestureRecognizer *)gesture{
    [self.infoTextView resignFirstResponder];
    [self.posTextField resignFirstResponder];
}




@end
