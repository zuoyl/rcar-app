//
//  SellerInfoViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 26/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "SellerInfoViewController.h"

#import "CheckBoxView.h"
#import "PhotoAlbumView.h"
#import "RegisterModel.h"
#import "PickerView.h"
#import "CitySelectViewController.h"
#import "SellerModel.h"
#import "SellerServiceModel.h"
#import "CarKindViewController.h"
#import "SellerMapViewController.h"
#import "SellerServiceAddViewController.h"
#import "SWTableViewCell.h"
#import "SellerServiceViewController.h"
#import "CitySelectViewController.h"
#import "SellerModel.h"



typedef enum {
    BasicInfoSection = 0,
    ServiceTimeSection,
    Image1Section,
    Image2Section,
    Image3Section,
    MaxSextion
} SectionIndex;


enum {
    Tag_UserTextField = 0x100,
    Tag_AddressTextField,
    Tag_PhoneTextField,
    Tag_LocationTextField,
    Tag_CarsTextField,
    Tag_ServiceStartTextField,
    Tag_ServiceEndTextField,
    Tag_ServiceStartPicker,
    Tag_ServiceEndPicker,
};

@interface SellerInfoViewController () <UITextFieldDelegate, CheckBoxViewDelegate, MxAlertViewDelegate, PickerViewDelegate, CitySelectDelegate, CarSelectionViewDelegate, SellerMapViewDelegate, SWTableViewCellDelegate>
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation SellerInfoViewController {
    PhotoAlbumView *_album1;
    PhotoAlbumView *_album2;
    PhotoAlbumView *_album3;
    BOOL _isEditMode;
    SellerModel *_seller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商家信息";
    self.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    
    _isEditMode = false;
    _seller = [SellerModel sharedClient];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editSelelrInfoBtnClicked:)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightItem;
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
    if ([controller respondsToSelector:@selector(setDelegate:)]) {
        [controller setValue:self forKey:@"delegate"];
        return;
    }
    if ([segue.identifier isEqualToString:@"seller_map"]) {
        [controller setValue:self forKey:@"delegate"];
        return;
    }
}


- (void)editSelelrInfoBtnClicked:(id)sender {
    if (_isEditMode == false) {
        _isEditMode = true;
        [_album1 changeMode:PhotoAlbumMode_Edit];
        [_album2 changeMode:PhotoAlbumMode_Edit];
        [_album3 changeMode:PhotoAlbumMode_Edit];
       [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return MaxSextion;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == BasicInfoSection) return 4;
    else if (section == ServiceTimeSection) return 3;
    else return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    SWTableViewCell *cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    
    if (indexPath.section == BasicInfoSection){
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            cell.textLabel.text = @"商家名称";
            UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(120.f, 8.f, self.tableView.frame.size.width - 140.f, 21.f)];
            textField.tag = Tag_UserTextField;
            textField.keyboardType = UIKeyboardTypeAlphabet;
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            textField.text = _seller.name;
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.font = [UIFont systemFontOfSize:15.f];
            textField.textColor = (_isEditMode == true)?[UIColor blackColor]:[UIColor lightGrayColor];
            [textField setEnabled:_isEditMode];
            [cell addSubview:textField];
            
        } else if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            cell.textLabel.text = @"商家地址";
            UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(120.f, 8.f, self.tableView.frame.size.width - 140.f, 21.f)];
            textField.tag = Tag_AddressTextField;
            textField.keyboardType = UIKeyboardTypeAlphabet;
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            textField.text = _seller.address;
            
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.font = [UIFont systemFontOfSize:15.f];
            [textField setEnabled:_isEditMode];
            textField.textColor = (_isEditMode == true)?[UIColor blackColor]:[UIColor lightGrayColor];
            
            
            [cell addSubview:textField];
            
        } else if (indexPath.row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            cell.textLabel.text = @"联系电话";
            UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(120.f, 8.f, self.tableView.frame.size.width - 140.f, 21.f)];
            textField.tag = Tag_PhoneTextField;
            textField.keyboardType = UIKeyboardTypePhonePad;
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            
            textField.text = _seller.telephone;
            [textField setEnabled:_isEditMode];
            textField.textColor = (_isEditMode == true)?[UIColor blackColor]:[UIColor lightGrayColor];
            
            textField.keyboardType = UIKeyboardTypePhonePad;
            textField.font = [UIFont systemFontOfSize:15.f];
            [cell addSubview:textField];
            
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"商家地理位置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(150.f, 8.f, self.tableView.frame.size.width - 160.f, 21.f)];
            textField.tag = Tag_LocationTextField;
            textField.keyboardType = UIKeyboardTypeAlphabet;
            textField.returnKeyType = UIReturnKeyDone;
            textField.textColor = (_isEditMode == true)?[UIColor blackColor]:[UIColor lightTextColor];
            
            
            textField.delegate = self;
            if (_seller.location != nil) {
                NSNumber *lat = [_seller.location objectForKey:@"lat"];
                NSNumber *lng = [_seller.location objectForKey:@"lng"];
                textField.text = [NSString stringWithFormat:@"%@(%@, %@)", _seller.city, lat, lng];
            } else {
                textField.text = @"没有标记商家位置";
            }
            [textField setEnabled:_isEditMode];
           
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.font = [UIFont systemFontOfSize:15.f];
            [cell addSubview:textField];
        }
    } else if (indexPath.section == ServiceTimeSection){ // service
        if (indexPath.row == 0) {
            cell.textLabel.text = @"服务车型";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(120.f, 8.f, self.tableView.frame.size.width - 140.f, 21.f)];
            textField.tag = Tag_CarsTextField;
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            if (_seller.cars.count > 0)
                textField.text = [NSString stringWithFormat:@"已经设定了%lu种车型", _seller.cars.count];
            else
                textField.text = @"没有设定车型";
            [textField setEnabled:_isEditMode];
            textField.textColor = (_isEditMode == true)?[UIColor blackColor]:[UIColor lightGrayColor];
            
            
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.font = [UIFont systemFontOfSize:15.f];
            [cell addSubview:textField];
            
        }
        else if (indexPath.row == 1) { // service start time
            cell.textLabel.text = @"营业开始时间";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(150.f, 8.f, self.tableView.frame.size.width - 160.f, 21.f)];
            textField.tag = Tag_ServiceStartTextField;
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            
            textField.text = _seller.service_start_time;
            [textField setEnabled:_isEditMode];
            textField.textColor = (_isEditMode == true)?[UIColor blackColor]:[UIColor lightGrayColor];
            
            
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.font = [UIFont systemFontOfSize:15.f];
            [cell addSubview:textField];
            
        } else if (indexPath.row == 2) { // service end time
            cell.textLabel.text = @"营业结束时间";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(150.f, 8.f, self.tableView.frame.size.width - 160.f, 21.f)];
            textField.tag = Tag_ServiceEndTextField;
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            [textField setEnabled:_isEditMode];
            textField.textColor = (_isEditMode == true)?[UIColor blackColor]:[UIColor lightGrayColor];
            
            
            textField.text = _seller.service_end_time;
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.font = [UIFont systemFontOfSize:15.f];
            [cell addSubview:textField];
            
        }
    } else if (indexPath.section == Image1Section) {
        if (!_album1) {
            _album1 = [PhotoAlbumView initWithViewController:self frame:cell.frame mode:PhotoAlbumMode_View];
            [_album1 loadImages:_seller.face_images];
        }
        [cell addSubview:_album1];
        _album1.maxOfImage = 1;
        
    } else if (indexPath.section == Image2Section) {
        if (!_album2) {
            _album2 = [PhotoAlbumView initWithViewController:self frame:cell.frame mode:PhotoAlbumMode_View];
            [_album2 loadImages:_seller.internal_images];
        }
        [cell addSubview:_album2];
        _album2.maxOfImage = 4;
        
    } else if (indexPath.section == Image3Section) {
        if (!_album3) {
            _album3 = [PhotoAlbumView initWithViewController:self frame:cell.contentView.frame mode:PhotoAlbumMode_View];
            [_album3 loadImages:_seller.eco_images];
        }
        [cell addSubview:_album3];
        _album3.maxOfImage = 2;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_isEditMode == true && section == Image3Section) return 40.f;
    else return 0.f;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == Image1Section ||
        indexPath.section == Image2Section ||
        indexPath.section == Image3Section )
        return 90.f;
    else
        return 35.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"地址信息", @"车型和营业时间", @"门头照片", @"店内照片", @"营业执照照片(必须)", @"必要信息填写完毕后，可以选择提交"];
    
    // reason is not known
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0, 320.f, 30.f)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 0, 300.f, 30.f)];
    label.text = [titles objectAtIndex:section];
    label.font = [UIFont systemFontOfSize:15.f];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    footerView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    [footerView addSubview:label];
    
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_isEditMode == true && section == Image3Section) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 35.f)];
        if (self.submitBtn == nil) {
            self.submitBtn = [[UIButton alloc]initWithFrame:footerView.frame];
            [self.submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.submitBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
            self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        }
        [footerView addSubview:self.submitBtn];
        return footerView;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)submitBtnClicked:(id)sender {
    if ([self checkInfoValidity])
        [self updateSellerInfo];
}


#pragma makr - UITextFiledDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == Tag_LocationTextField) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SellerMapViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SellerMapView"];
        controller.delegate = self;
        controller.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
        return NO;
        
    } else if (textField.tag == Tag_ServiceStartTextField) {
        NSDate *date = [[NSDate alloc]init];
        PickerView *picker = [[PickerView alloc]initDatePickWithDate:date datePickerMode:UIDatePickerModeTime isHaveNavControler:NO];
        picker.delegate = self;
        picker.tag = Tag_ServiceStartPicker;
        [picker show];
        return NO;
        
    } else if (textField.tag == Tag_ServiceEndTextField) {
        NSDate *date = [[NSDate alloc]init];
        PickerView *picker = [[PickerView alloc]initDatePickWithDate:date datePickerMode:UIDatePickerModeTime isHaveNavControler:NO];
        picker.delegate = self;
        picker.tag = Tag_ServiceEndPicker;
        [picker show];
        return NO;
    } else if (textField.tag == Tag_CarsTextField) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CarKindViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CarKindSelectionView"];
        controller.hidesBottomBarWhenPushed = YES;
        controller.delegate = self;
        controller.presetCars = _seller.cars;
        [self.navigationController pushViewController:controller animated:YES];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == Tag_AddressTextField) _seller.address = textField.text;
    else if (textField.tag == Tag_PhoneTextField) _seller.telephone = textField.text;
    else if (textField.tag == Tag_UserTextField) _seller.name = textField.text;
}

#pragma mark - CarSelectViewDelegate
- (void)citySelected:(NSString *)name {
    _seller.city = name;
}

#pragma mark - PickerViewDelegate
-(void)pickerViewDone:(PickerView *)pickView result:(NSString *)result {
    if (pickView.tag == Tag_ServiceStartPicker) {
        NSArray *array=[result componentsSeparatedByString:@"+"];
        _seller.service_start_time = [array objectAtIndex:0];
        _seller.service_start_time = [_seller.service_start_time substringWithRange:NSMakeRange(11, 5)];
        
        
        UITextField *textField = (UITextField *)[self.view viewWithTag:Tag_ServiceStartTextField];
        textField.text = _seller.service_start_time;
        
    }
    if (pickView.tag == Tag_ServiceEndPicker) {
        NSArray *array=[result componentsSeparatedByString:@"+"];
        _seller.service_end_time = [array objectAtIndex:0];
        _seller.service_end_time = [_seller.service_end_time substringWithRange:NSMakeRange(11, 5)];
        
        UITextField *textField = (UITextField *)[self.view viewWithTag:Tag_ServiceEndTextField];
        textField.text = _seller.service_end_time;
    }
}


- (BOOL)checkInfoValidity {
    if (_seller.name == nil || [_seller.name isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"商家名称没有填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (_seller.location == nil ) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"商家地址没有标记" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (_seller.city == nil || [_seller.city isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"商家所在城市没有选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (_seller.telephone == nil || [_seller.telephone isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"商家联系电话没有填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (_seller.service_start_time == nil || [_seller.service_start_time isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务开始时间没有设定" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (_seller.service_end_time == nil || [_seller.service_end_time isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务结束时间没有设定" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    
    if (_album1.numberOfImage == 0) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有选择门头照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (_album3.numberOfImage == 0) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有选择营业执照照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    return true;
}




- (void)updateSellerInfo {
    if (![RCar isConnected]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不能连接,请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params addEntriesFromDictionary:@{@"role":@"seller", @"seller_id":_seller.seller_id, @"shop_name":_seller.name, @"shop_city":_seller.city, @"shop_address":_seller.address, @"shop_telephone":_seller.telephone, @"service_start_time":_seller.service_start_time, @"service_end_time":_seller.service_end_time, @"cars":_seller.cars}];
    
    if (_seller.location != nil) {
        [params setValue:_seller.location forKey:@"location"];
    }
    
    // add images
    [params setValue:[NSNumber numberWithInteger:_album1.numberOfImage] forKey:@"face_images"];
    [params setValue:[NSNumber numberWithInteger:_album2.numberOfImage] forKey:@"internal_images"];
    [params setValue:[NSNumber numberWithInteger:_album3.numberOfImage] forKey:@"eco_images"];
    
    
    __block SellerInfoViewController *blockself = self;
    [self.submitBtn setEnabled:NO];
    
    [RCar PUT:rcar_api_seller modelClass:nil config:nil params:params success:^(NSDictionary *dict) {
        NSString *result = [dict objectForKey:@"api_result"];
        if (result.integerValue == APIE_OK) {
            // get images name and upload images
            NSArray *faceImageNames = [dict objectForKey:@"face_images"];
            NSArray *internalImageNames = [dict objectForKey:@"internal_images"];
            NSArray *ecoIimageNames = [dict objectForKey:@"ecoImages"];
            
            NSMutableArray *names = [[NSMutableArray alloc]init];
            [names addObjectsFromArray:faceImageNames];
            [names addObjectsFromArray:internalImageNames];
            [names addObjectsFromArray:ecoIimageNames];
            
            // get all data
            NSMutableArray *images = [[NSMutableArray alloc]init];
            [images addObjectsFromArray:[_album1 getImageDatasWithJpegCompress:0.5]];
            [images addObjectsFromArray:[_album2 getImageDatasWithJpegCompress:0.5]];
            [images addObjectsFromArray:[_album3 getImageDatasWithJpegCompress:0.5]];
            [RCar uploadImage:images names:names target:@"seller" success:^(id result) {
                [blockself handleUpdateCompleted];
            } failure:^(NSString *errorStr) {
                [blockself handleUpdateCompleted];
            }];
            [blockself handleUpdateCompleted];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            [blockself.submitBtn setEnabled:YES];
            return;
            
        }
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不能连接,请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        [blockself.submitBtn setEnabled:YES];
        return;
        
    }];
    
}

- (void)handleError:(NSString *)error {
    [self.submitBtn setEnabled:YES];
    
    MxAlertView *alert = [[MxAlertView alloc] initWithTitle:nil message:@"商铺注册失败，请重新提交注册" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
    [alert show:self];
    return;
    
}
- (void)handleUpdateCompleted {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - CarKindSelectionViewDelegate
- (CarSelectionMode)onGetCarSelectionMode {
    return CarSelectionModeMultiply;
}
- (CarSelectionType)onGetCarSelectionType {
    return  CarSelectionKindOnly;
}

- (void)carSelectionCompleted:(NSArray *)result {
    UITextField *textField = (UITextField *)[self.view viewWithTag:Tag_CarsTextField];
    textField.text = [NSString stringWithFormat:@"已经设定了%lu种车型", _seller.cars.count];

    [_seller.cars removeAllObjects];
    [_seller.cars addObjectsFromArray:result];
}

#pragma mark - SellerMapViewDelegate
- (void) locationSelected:(NSString *)address locaiton:(CLLocationCoordinate2D)location {
    NSNumber *lat = [NSNumber numberWithDouble:location.latitude];
    NSNumber *lng = [NSNumber numberWithDouble:location.longitude];
    
    //_location = [NSString stringWithFormat:@"(%@,%@)", lat, lng];
    _seller.location = [[NSMutableDictionary alloc]initWithDictionary: @{@"lat":lat, @"lng":lng}];
    
    _seller.city = address;
    // update cell
    [self.tableView reloadData];
}

@end
