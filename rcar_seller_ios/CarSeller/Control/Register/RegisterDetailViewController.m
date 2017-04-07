//
//  RegisterDetailViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 16/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "RegisterDetailViewController.h"
#import "CheckBoxView.h"
#import "PhotoAlbumView.h"
#import "RegisterModel.h"
#import "PickerView.h"
#import "CitySelectViewController.h"
#import "SellerModel.h"
#import "SellerServiceModel.h"
#import "CarKindViewController.h"
#import "SellerMapViewController.h"
#import "RegisterModel.h"
#import "SellerServiceAddViewController.h"
#import "SWTableViewCell.h"
#import "SellerServiceViewController.h"
#import "CitySelectViewController.h"
#import "SSTextView.h"



typedef enum {
    BasicInfoSection = 0,
    ServiceTimeSection,
    ServiceItemSection,
    Image1Section,
    Image2Section,
    Image3Section,
    MaxSextion
} SectionIndex;

@interface RegisterDetailViewController () <UITextFieldDelegate, CheckBoxViewDelegate, MxAlertViewDelegate, PickerViewDelegate, CitySelectDelegate, CarSelectionViewDelegate, SellerMapViewDelegate, SellerServiceAddViewDelegate, SWTableViewCellDelegate, UITextViewDelegate>
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation RegisterDetailViewController {
    PhotoAlbumView *_album1;
    PhotoAlbumView *_album2;
    PhotoAlbumView *_album3;
    RegisterModel *_registerModel;
  }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商户注册(2/2)";
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelRegister:)];
    [leftItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _registerModel = [RegisterModel sharedClient];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelRegister:(id)sender {
    RegisterModel *model = [RegisterModel sharedClient];
    model.step = RegisterModelStep2;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"需注册商户后才能够使用" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *controller = segue.destinationViewController;
    if ([controller respondsToSelector:@selector(setDelegate:)]) {
        [controller setValue:self forKey:@"delegate"];
    }
    if ([segue.identifier isEqualToString:@"seller_map"]) {
        [controller setValue:self forKey:@"delegate"];
        return;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return MaxSextion;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == BasicInfoSection) return 5;
    else if (section == ServiceTimeSection) return 3;
    else if (section == ServiceItemSection) {
        if (_registerModel.services.count == 0) return 1;
        else return _registerModel.services.count;
    } else return 1;
}

enum {
    Tag_UserTextField = 100,
    Tag_IntroTextField,
    Tag_AddressTextField,
    Tag_PhoneTextField,
    Tag_LocationTextField,
    Tag_CarsTextField,
    Tag_ServiceStartTextField,
    Tag_ServiceEndTextField,
    Tag_ServiceStartPicker,
    Tag_ServiceEndPicker,
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    SWTableViewCell *cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    
    CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
    
    
    if (indexPath.section == BasicInfoSection){
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            cell.textLabel.text = @"商家名称";
            UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(120.f, 0.f, self.tableView.frame.size.width - 140.f, height)];
            textField.contentMode = UIControlContentVerticalAlignmentCenter;
            textField.tag = Tag_UserTextField;
            textField.keyboardType = UIKeyboardTypeAlphabet;
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            
            if (_registerModel.name == nil || [_registerModel.name isEqualToString:@""])
                textField.placeholder = @"商家名称,必填";
            else
                textField.text = _registerModel.name;
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.font = [UIFont systemFontOfSize:15.f];
            [cell addSubview:textField];
        } else if (indexPath.row == 1) {
            SSTextView *textView = [[SSTextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60.f)];
            textView.font = [UIFont systemFontOfSize:15.f];
            textView.contentMode = UIControlContentVerticalAlignmentCenter;
            textView.keyboardType = UIKeyboardTypeAlphabet;
            textView.returnKeyType = UIReturnKeyDone;
            
            [textView setContentInset:UIEdgeInsetsMake(5, 0, 0, 0)];
            if (_registerModel.intro == nil || [_registerModel.intro isEqualToString:@""])
                textView.placeholder = @"商家概要介绍";
            else
                textView.text = _registerModel.intro;
            textView.tag = Tag_IntroTextField;
            textView.delegate = self;
            [cell addSubview:textView];
        
        } else if (indexPath.row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            cell.textLabel.text = @"商家地址";
            UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(120.f, 0.f, self.tableView.frame.size.width - 140.f, height)];
            textField.contentMode = UIControlContentVerticalAlignmentCenter;
            textField.tag = Tag_AddressTextField;
            textField.keyboardType = UIKeyboardTypeAlphabet;
            textField.returnKeyType = UIReturnKeyDone;
            
            textField.delegate = self;
            if (_registerModel.address == nil || [_registerModel.address isEqualToString:@""])
                textField.placeholder = @"商家地址,必填";
            else
                textField.text = _registerModel.address;
            
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.font = [UIFont systemFontOfSize:15.f];
            [cell addSubview:textField];
            
        } else if (indexPath.row == 3) {
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            cell.textLabel.text = @"联系电话";
            UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(120.f, 0.f, self.tableView.frame.size.width - 140.f, height)];
            textField.contentMode = UIControlContentVerticalAlignmentCenter;
            textField.tag = Tag_PhoneTextField;
            textField.keyboardType = UIKeyboardTypePhonePad;
            textField.returnKeyType = UIReturnKeyDone;
            
            textField.delegate = self;
            
            if (_registerModel.telephone == nil || [_registerModel.telephone isEqualToString:@""])
                textField.placeholder = @"联络电话,必填";
            else
                textField.text = _registerModel.telephone;
            
            textField.keyboardType = UIKeyboardTypePhonePad;
            textField.font = [UIFont systemFontOfSize:15.f];
            [cell addSubview:textField];
            
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"商家地理位置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(150.f, 0.f, self.tableView.frame.size.width - 160.f, height)];
            textField.contentMode = UIControlContentVerticalAlignmentCenter;
            textField.tag = Tag_LocationTextField;
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            if (_registerModel.location == nil)
                textField.placeholder = @"请标记商家位置,必填";
            else {
                NSNumber *lat = [_registerModel.location objectForKey:@"lat"];
                NSNumber *lng = [_registerModel.location objectForKey:@"lng"];
                NSString *location = [NSString stringWithFormat:@"%@(%@, %@)", _registerModel.city, lat, lng];
                textField.text = location;
            }
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.font = [UIFont systemFontOfSize:15.f];
            [cell addSubview:textField];
        }
    } else if (indexPath.section == ServiceTimeSection){ // service
        if (indexPath.row == 0) {
            cell.textLabel.text = @"服务车型";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(120.f, 0.f, self.tableView.frame.size.width - 140.f, height)];
            textField.contentMode = UIControlContentVerticalAlignmentCenter;
            textField.tag = Tag_CarsTextField;
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            
            if (_registerModel.carText == nil || [_registerModel.carText isEqualToString:@""])
                textField.placeholder = @"请选择服务车型";
            else
                textField.text = _registerModel.carText;
            
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.font = [UIFont systemFontOfSize:15.f];
            [cell addSubview:textField];
            
        }
        else if (indexPath.row == 1) { // service start time
            cell.textLabel.text = @"营业开始时间";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(150.f, 0.f, self.tableView.frame.size.width - 160.f, height)];
            textField.contentMode = UIControlContentVerticalAlignmentCenter;
            textField.tag = Tag_ServiceStartTextField;
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            
            if (_registerModel.serviceStartTime == nil || [_registerModel.serviceStartTime isEqualToString:@""])
                textField.placeholder = @"请选择营业开始时间,必填";
            else
                textField.text = _registerModel.serviceStartTime;
                
            
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.font = [UIFont systemFontOfSize:15.f];
            [cell addSubview:textField];
            
        } else if (indexPath.row == 2) { // service end time
            cell.textLabel.text = @"营业结束时间";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(150.f, 0.f, self.tableView.frame.size.width - 160.f, height)];
            textField.contentMode = UIControlContentVerticalAlignmentCenter;
            textField.tag = Tag_ServiceEndTextField;
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            
            if (_registerModel.serviceEndTime == nil || [_registerModel.serviceEndTime isEqualToString:@""])
                textField.placeholder = @"请选择营业结束时间,必填";
            else
                textField.text = _registerModel.serviceEndTime;
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.font = [UIFont systemFontOfSize:15.f];
            [cell addSubview:textField];
            
        }
    } else if (indexPath.section == ServiceItemSection) { // service list
        if (_registerModel.services.count == 0) {
            cell.textLabel.text = @"没有添加商家服务";
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        } else {
            SellerServiceModel *service = [_registerModel.services objectAtIndex:indexPath.row];
            cell.textLabel.text = service.title;
            cell.detailTextLabel.text = service.price;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
            NSMutableArray *buttons = [[NSMutableArray alloc]init];
            [buttons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除服务"];
            [cell setRightUtilityButtons:buttons WithButtonWidth:100];
            cell.delegate = self;
            cell.path = indexPath;
        }
        
    } else if (indexPath.section == Image1Section) {
        if (!_album1)
            _album1 = [PhotoAlbumView initWithViewController:self frame:cell.frame mode:PhotoAlbumMode_Edit];
        [cell addSubview:_album1];
        _album1.maxOfImage = 1;
   
    } else if (indexPath.section == Image2Section) {
        if (!_album2)
            _album2 = [PhotoAlbumView initWithViewController:self frame:cell.frame mode:PhotoAlbumMode_Edit];
        [cell addSubview:_album2];
        _album2.maxOfImage = 4;
        
    } else if (indexPath.section == Image3Section) {
        if (!_album3)
            _album3 = [PhotoAlbumView initWithViewController:self frame:cell.contentView.frame mode:PhotoAlbumMode_Edit];
        [cell addSubview:_album3];
        _album3.maxOfImage = 2;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == Image3Section) return 35.f;
    else return 0.f;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == BasicInfoSection && indexPath.row == 1)
        return 60.f;
    else if (indexPath.section == Image1Section ||
        indexPath.section == Image2Section ||
        indexPath.section == Image3Section )
        return 90.f;
    else if (indexPath.section == ServiceItemSection)
        return 35.f;
    else
        return 35.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"地址信息", @"车型和营业时间", @"服务项目", @"门头照片", @"店内照片", @"营业执照照片(必须)", @"必要信息填写完毕后，可以选择提交"];
    
    // reason is not known
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0, 320.f, 30.f)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 0, 300.f, 30.f)];
    label.contentMode = UIControlContentVerticalAlignmentCenter;
    label.text = [titles objectAtIndex:section];
    label.font = [UIFont systemFontOfSize:15.f];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    footerView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    [footerView addSubview:label];
    
    if (section == ServiceItemSection) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 0, 100, 30)];
        [button setTitle:@"添加服务" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        button.backgroundColor = [UIColor colorWithHex:@"509400"];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addService:) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView addSubview:button];
    }
    
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == Image3Section) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.f)];
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
    if (indexPath.section == ServiceItemSection && _registerModel.services.count > 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
        SellerServiceViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SellerServiceView"];
        controller.delegate = self;
        controller.model = [_registerModel.services objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)submitBtnClicked:(id)sender {
    if ([self checkInfoValidity])
        [self registerSeller];
}

- (void)addService:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Seller" bundle:nil];
    SellerServiceAddViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AddServiceView"];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = cell.path;
    [_registerModel.services removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

#pragma mark - SellerAddServiceDelegate
- (void)sellerServiceAddCompleted:(SellerServiceModel *)service {
    if (![_registerModel.services containsObject:service])
        [_registerModel.services addObject:service];
    [self.tableView reloadData];
}

#pragma makr - UITextFiledDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == Tag_LocationTextField) {
        [self performSegueWithIdentifier:@"seller_map" sender:self];
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
        [self performSegueWithIdentifier:@"car_kind" sender:self];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == Tag_AddressTextField) _registerModel.address = textField.text;
    else if (textField.tag == Tag_PhoneTextField) _registerModel.telephone = textField.text;
    else if (textField.tag == Tag_UserTextField) _registerModel.name = textField.text;
}
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    _registerModel.intro = textView.text;
}

#pragma mark - CarSelectViewDelegate
- (void)citySelected:(NSString *)name {
    _registerModel.city = name;
}

#pragma mark - PickerViewDelegate
-(void)pickerViewDone:(PickerView *)pickView result:(NSString *)result {
    if (pickView.tag == Tag_ServiceStartPicker) {
        NSArray *array=[result componentsSeparatedByString:@"+"];
        _registerModel.serviceStartTime = [array objectAtIndex:0];
        _registerModel.serviceStartTime = [_registerModel.serviceStartTime substringWithRange:NSMakeRange(11, 5)];
        
        
        UITextField *textField = (UITextField *)[self.view viewWithTag:Tag_ServiceStartTextField];
        textField.text = _registerModel.serviceStartTime;
        
    }
    if (pickView.tag == Tag_ServiceEndPicker) {
        NSArray *array=[result componentsSeparatedByString:@"+"];
        _registerModel.serviceEndTime = [array objectAtIndex:0];
        _registerModel.serviceEndTime = [_registerModel.serviceEndTime substringWithRange:NSMakeRange(11, 5)];
        
        UITextField *textField = (UITextField *)[self.view viewWithTag:Tag_ServiceEndTextField];
        textField.text = _registerModel.serviceEndTime;
    }
}


- (BOOL)checkInfoValidity {
    if (_registerModel.name == nil || [_registerModel.name isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"商家名称没有填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (_registerModel.intro == nil || [_registerModel.intro isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"商家概要介绍没有填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
#if 0
    if (_registerModel.location == nil ) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"商家地址没有标记" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
#endif
    if (_registerModel.city == nil || [_registerModel.city isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"商家所在城市没有选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (_registerModel.telephone == nil || [_registerModel.telephone isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"商家联系电话没有填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (_registerModel.serviceStartTime == nil || [_registerModel.serviceStartTime isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务开始时间没有设定" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (_registerModel.serviceEndTime == nil || [_registerModel.serviceEndTime isEqualToString:@""]) {
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




- (void)registerSeller {
    if (![RCar isConnected]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不能连接,请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    // create service list
    NSMutableArray *services = [[NSMutableArray alloc]init];
    for (SellerServiceModel *service in _registerModel.services) {
        NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
        [item setObject:service.type forKey:@"type"];
        [item setObject:service.title forKey:@"title"];
        [item setObject:service.detail forKey:@"detail"];
        [item setObject:service.price forKey:@"price"];
        [services addObject:item];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params addEntriesFromDictionary:@{@"role":@"seller", @"seller_id":_registerModel.seller_id, @"pwd":_registerModel.pwd, @"shop_name":_registerModel.name, @"shop_city":_registerModel.city, @"shop_address":_registerModel.address, @"shop_telephone":_registerModel.telephone, @"service_start_time":_registerModel.serviceStartTime, @"service_end_time":_registerModel.serviceEndTime, @"services":services, @"cars":_registerModel.cars, @"intro":_registerModel.intro}];
    if (_registerModel.location != nil)
        [params setValue:_registerModel.location forKey:@"location"];
    
    // add images
    [params setValue:[NSNumber numberWithInteger:_album1.numberOfImage] forKey:@"face_images"];
    [params setValue:[NSNumber numberWithInteger:_album2.numberOfImage] forKey:@"internal_images"];
    [params setValue:[NSNumber numberWithInteger:_album3.numberOfImage] forKey:@"eco_images"];
    
    __block RegisterDetailViewController *blockself = self;
    [self.submitBtn setEnabled:NO];
    [RCar POST:rcar_api_seller modelClass:nil config:nil params:params success:^(NSDictionary *dict) {
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
                [blockself handleRegisterCompleted];
            } failure:^(NSString *errorStr) {
                [blockself handleRegisterCompleted];
            }];
            [blockself handleRegisterCompleted];
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

- (void)handleRegisterCompleted {
    [self.submitBtn setEnabled:YES];
    
    // update seller model
    SellerModel *seller = [SellerModel sharedClient];
    seller.name = _registerModel.name;
    seller.telephone = _registerModel.telephone;
    seller.address = _registerModel.address;
    seller.city = _registerModel.city;
    seller.seller_id = _registerModel.seller_id;
    seller.islogin = false;
    seller.pwd = _registerModel.pwd;
    
    // update services
    seller.service_start_time = _registerModel.serviceStartTime;
    seller.service_end_time = _registerModel.serviceEndTime;
    [seller.services addObjectsFromArray:_registerModel.services];
    [self performSegueWithIdentifier:@"show_main" sender:self];
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
    NSString *carNumber = [NSString stringWithFormat:@"%lu", (unsigned long)result.count];
    _registerModel.carText = [@"已选择" stringByAppendingString:carNumber];
    _registerModel.carText = [_registerModel.carText stringByAppendingString:@"种车系"];
    textField.text = _registerModel.carText;
    
    [_registerModel.cars removeAllObjects];
    [_registerModel.cars addObjectsFromArray:result];
}

#pragma mark - SellerMapViewDelegate
- (void) locationSelected:(NSString *)address locaiton:(CLLocationCoordinate2D)location {
    NSNumber *lat = [NSNumber numberWithDouble:location.latitude];
    NSNumber *lng = [NSNumber numberWithDouble:location.longitude];
    
    //_location = [NSString stringWithFormat:@"(%@,%@)", lat, lng];
    _registerModel.location = [[NSMutableDictionary alloc]initWithDictionary: @{@"lat":lat, @"lng":lng}];
    _registerModel.city = address;
    // update cell
    [self.tableView reloadData];
}


@end
