//
//  CarAddViewController.m
//  CarUser
//
//  Created by huozj on 1/19/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "CarAddViewController.h"
#import "CarListViewController.h"
#import "CarInfoRepository.h"
#import "CarModel.h"
#import "PickerView.h"
#import "CarKindViewController.h"
#import "SSTextView.h"

@interface CarAddViewController () <PickerViewDelegate, UITextFieldDelegate, CarKindViewDelegate>
@property (nonatomic, strong) UITextField *numberField;
@property (nonatomic, strong) UITextField *mileageField;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, assign) BOOL isNewCar;
@end

@implementation CarAddViewController

@synthesize model;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.model != nil) {
        self.isNewCar = false;
        self.navigationItem.title = @"车辆编辑";
    } else {
        self.isNewCar = true;
        self.model = [[CarInfoModel alloc]init];
        self.navigationItem.title = @"添加车辆";
    }
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    // add edit button
    
    
    
    self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activity setFrame:CGRectMake(0, 0, 40, 40)];
    [self.activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
 //   [self.addBtn setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.addBtn.frame.size.height)];
    
    __block CarAddViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.sectionHeight = 5;
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"UIControlCell1";
            staticContentCell.cellHeight = 40.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"车辆型号:";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            if (blockself.isNewCar)
                cell.detailTextLabel.text = @"点击选择车型";
            cell.detailTextLabel.text = blockself.model.brand;
        } whenSelected:^(NSIndexPath *indexPath) {
            [blockself performSegueWithIdentifier:@"car_info_kind" sender:blockself];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell2";
            staticContentCell.cellHeight = 40.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"车牌号码:";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            if (blockself.numberField == nil) {
                blockself.numberField = [[UITextField alloc]initWithFrame:CGRectMake(blockself.view.frame.size.width - 140, 0,  120, 40.f)];
                blockself.numberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                blockself.numberField.keyboardType = UIKeyboardTypeNamePhonePad;
                blockself.numberField.returnKeyType = UIReturnKeyDone;
                
            }
            [cell.contentView addSubview:blockself.numberField];
            if (blockself.isNewCar)
                blockself.numberField.placeholder = @"请输入车牌号";
            else
                blockself.numberField.text = blockself.model.platenumber;
            blockself.numberField.textAlignment = NSTextAlignmentRight;
            blockself.numberField.font = [UIFont systemFontOfSize:17.f];
            blockself.numberField.delegate = blockself;
            
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell3";
            staticContentCell.cellHeight = 40.f;
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"购买时间:";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            if (blockself.model.buy_date != nil)
                cell.detailTextLabel.text = blockself.model.buy_date;
            
        } whenSelected:^(NSIndexPath *indexPath) {
            NSDate *date = [[NSDate alloc]init];
            PickerView *picker = [[PickerView alloc]initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
            picker.delegate = blockself;
            [picker setToolbarTintColor:[UIColor colorWithHex:@"2480ff"]];
            [picker show];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell4";
            staticContentCell.cellHeight = 40.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"行驶路程:";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            if (blockself.mileageField == nil) {
                blockself.mileageField = [[UITextField alloc]initWithFrame:CGRectMake(blockself.view.frame.size.width - 140, 0,  120, 40.f)];
                blockself.mileageField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                
            }
            [cell.contentView addSubview:blockself.mileageField];
            if (blockself.isNewCar)
                blockself.mileageField.placeholder = @"请输入里程数";
            else
                blockself.mileageField.text = blockself.model.miles;
            blockself.mileageField.textAlignment = NSTextAlignmentRight;
            blockself.mileageField.font = [UIFont systemFontOfSize:17.f];
            blockself.mileageField.delegate = blockself;
            blockself.mileageField.keyboardType = UIKeyboardTypeNumberPad;
            blockself.mileageField.returnKeyType = UIReturnKeyDone;
                
            
        }];
        
        section.sectionFooterHeight = 44.f;
        
        blockself.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, blockself.view.frame.size.width, section.sectionFooterHeight)];;
        [blockself.submitBtn addTarget:blockself action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        blockself.submitBtn.backgroundColor = [UIColor colorWithHex:@"2480ff"];
        [blockself.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [blockself.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        blockself.submitBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [blockself.submitBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        section.footerView = blockself.submitBtn;
        
        
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideKeyboard:(UITapGestureRecognizer *)gesture{
}

#pragma mark -UIButtonDelegate
- (void)addBtnClicked:(id)sender {
    if (self.isNewCar)
        [self addCarInfo:self.model];
    else
        [self updateCarInfo:self.model];
    
}

- (BOOL)checkParameterValidity {
    if (self.model.brand == nil || [self.model.brand isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有选择车型" delegate:nil cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
        [alert show:self];
        return NO;
    }
    if (self.model.platenumber == nil || [self.model.platenumber isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写车牌号" delegate:nil cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
        [alert show:self];
        return NO;
    }
    if (self.model.miles == nil || [self.model.miles isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写车辆里程数" delegate:nil cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
        [alert show:self];
        return NO;
    }
    if (self.model.buy_date == nil || [self.model.buy_date isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写车辆购买时间" delegate:nil cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
        [alert show:self];
        return NO;
    }
    return YES;
}


- (void)addCarInfo:(CarInfoModel *)carInfo {
    if (![self checkParameterValidity]) return;
    
    [self.activity startAnimating];
    UserModel *userModel = [UserModel sharedClient];
    NSDictionary *params = @{@"role":@"user",
                             @"user_id":userModel.user_id,
                             @"kind":self.model.kind,
                             @"brand":self.model.brand,
                             @"platenumber":self.model.platenumber,
                             @"buy_date":self.model.buy_date,
                             @"miles":self.model.miles};
    
    __block CarAddViewController *blockself = self;
    [RCar POST:rcar_api_user_car modelClass:@"CarInfoModel" config:nil params:params success:^(CarInfoModel *result) {
        [blockself.activity stopAnimating];
        if (result.api_result == APIE_OK) {
            [blockself.navigationController popViewControllerAnimated:YES];
            if (blockself.delegate)
                [blockself.delegate carAddViewCompleted:blockself.model];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    }failure:^(NSString *errorStr) {
        [blockself.activity stopAnimating];
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
    
}

- (void)updateCarInfo:(CarInfoModel *)carInfo {
    if (![self checkParameterValidity]) return;
    
    [self.activity startAnimating];
    UserModel *userModel = [UserModel sharedClient];
    NSDictionary *params = @{@"role":@"user",
                             @"user_id":userModel.user_id,
                             @"brand":self.model.brand,
                             @"platenumber":self.model.platenumber,
                             @"buy_date":self.model.buy_date,
                             @"miles":self.model.miles};
    __block CarAddViewController *blockself = self;
    [RCar PUT:rcar_api_user_car modelClass:@"CarInfoModel" config:nil params:params success:^(CarInfoModel *result) {
        [blockself.activity stopAnimating];
        if (result.api_result == APIE_OK) {
            [blockself.navigationController popViewControllerAnimated:YES];
            if (blockself.delegate)
                [blockself.delegate carAddViewCompleted:blockself.model];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    }failure:^(NSString *errorStr) {
        [blockself.activity stopAnimating];
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
    
}

#pragma makr - UITextFiledDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//}
    
#pragma mark - PickerViewDelegate
-(void)pickerViewDone:(PickerView *)pickView result:(NSString *)result {
    NSArray *array=[result componentsSeparatedByString:@" "];
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPaths[2]];
    cell.detailTextLabel.text = array[0];
    
    // update model
    if (self.model == nil)
        self.model = [[CarInfoModel alloc]init];
    self.model.buy_date = array[0];
  //  [pickView remove];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *controller = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"car_info_kind"]) {
        [controller setValue:self forKey:@"delegate"];
        [controller setValue:@"single" forKey:@"viewMode"];
        [controller setValue:self forKey:@"rootViewController"];
    }
}

#pragma mark -CarKindViewDelegate
- (void)carKindViewComplete:(NSString *)brand types:(NSArray *)types {
    // update model
    if (self.model == nil)
        self.model = [[CarInfoModel alloc]init];
    
    self.model.kind = brand;
    self.model.brand = types[0];
    [self.tableView reloadData];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.model == nil)
        self.model = [[CarInfoModel alloc]init];
  
    if (textField == self.mileageField)
        self.model.miles = textField.text;
    if (textField == self.numberField)
        self.model.platenumber = textField.text;
    [textField resignFirstResponder];
}


@end
