//
//  UserInfoViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "UserInfoViewController.h"
#import "SellerModel.h"
#import "UserModel.h"
#include "CarKindViewController.h"
#import "UserGroupModel.h"
#import "PickerView.h"
#import "SSTextView.h"
#import "UserGroupAddViewController.h"
#import "MxTextField.h"

@interface UserInfoViewController () <CarSelectionViewDelegate, PickerViewDelegate, MxTextFieldDelegate, UserGroupAddViewDelegate, MxTextFieldDelegate>
@property (nonatomic, strong) UserModel *model;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *carKindTextField;
@property (nonatomic, strong) UITextField *carnoTextField;
@property (nonatomic, strong) MxTextField *carMilesTextField;
@property (nonatomic, strong) SSTextView *memoTextView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *carType;
@property (nonatomic, assign) BOOL flag;

@end

@implementation UserInfoViewController {
    SellerModel *_seller;
}
@synthesize user_id;
@synthesize editMode;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户信息";
    self.hidesBottomBarWhenPushed = YES;
    self.flag = NO;
    
    _seller = [SellerModel sharedClient];
    
    __block UserInfoViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.sectionHeight = 5;
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell1";
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"用户名称";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            if (blockself.nameTextField == nil) {
                blockself.nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(130, 0, blockself.tableView.frame.size.width - 150 , 35.f)];
                blockself.nameTextField.contentMode = UIControlContentVerticalAlignmentCenter;
                blockself.nameTextField.placeholder = @"请输入客户名称";
                blockself.nameTextField.font = [UIFont systemFontOfSize:15.f];
                blockself.nameTextField.textAlignment = UIControlContentHorizontalAlignmentRight;
                blockself.nameTextField.keyboardType = UIKeyboardTypeAlphabet;
                blockself.nameTextField.returnKeyType = UIReturnKeyDone;
            }
            blockself.nameTextField.text = blockself.model.name;
            blockself.nameTextField.textColor = [UIColor grayColor];
            blockself.nameTextField.textAlignment = NSTextAlignmentRight;
            [cell addSubview:blockself.nameTextField];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell2";
            staticContentCell.cellHeight = 35.f;
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"客户联系电话";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            cell.detailTextLabel.text = blockself.user_id;
        }];
        
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell4";
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"车牌号";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            
            if (blockself.carnoTextField == nil) {
                blockself.carnoTextField = [[UITextField alloc]initWithFrame:CGRectMake(130, 0, blockself.tableView.frame.size.width - 150 , 35.f)];
                blockself.carnoTextField.placeholder = @"请输入客户车牌号";
                blockself.carnoTextField.contentMode = UIControlContentVerticalAlignmentCenter;
                blockself.carnoTextField.font = [UIFont systemFontOfSize:15.f];
                blockself.carnoTextField.textAlignment = UIControlContentHorizontalAlignmentRight;
                blockself.carnoTextField.keyboardType = UIKeyboardTypeAlphabet;
                blockself.carnoTextField.returnKeyType = UIReturnKeyDone;
            }
            blockself.carnoTextField.text = blockself.model.car_no;
            blockself.carnoTextField.textAlignment = NSTextAlignmentRight;
            blockself.carnoTextField.textColor = [UIColor grayColor];
            [cell addSubview:blockself.carnoTextField];
        }];
        
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell5";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"车型";
            if (blockself.model.car_type && ![blockself.model.car_type isEqualToString:@""])
                cell.detailTextLabel.text = blockself.model.car_type;
            else if (blockself.carType != nil && ![blockself.carType isEqualToString:@""])
                cell.detailTextLabel.text = blockself.carType;
            else
                cell.detailTextLabel.text = @"未知";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            
        } whenSelected:^(NSIndexPath *indexPath) {
            if (blockself.editMode == YES) {
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                CarKindViewController *controller = [story instantiateViewControllerWithIdentifier:@"CarKindSelectionView"];
                controller.delegate = blockself;
                controller.rootController = blockself;
                blockself.hidesBottomBarWhenPushed = YES;
                [blockself.navigationController pushViewController:controller animated:YES];
            }
        }];
        
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell8";
            staticContentCell.cellHeight = 35.f;
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"车辆行驶公里数";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            
            if (blockself.carMilesTextField == nil) {
                blockself.carMilesTextField = [[MxTextField alloc]initWithFrame:CGRectMake(180, 0, blockself.tableView.frame.size.width - 200 , 35.f)];
                blockself.carMilesTextField.font = [UIFont systemFontOfSize:15.f];
                blockself.carMilesTextField.contentMode = UIControlContentVerticalAlignmentCenter;
                blockself.carMilesTextField.textAlignment = UIControlContentHorizontalAlignmentRight;
                blockself.carMilesTextField.keyboardType = UIKeyboardTypeNumberPad;
                blockself.carMilesTextField.returnKeyType = UIReturnKeyDone;
                blockself.carMilesTextField.mxDelegate = blockself;
                [blockself.carMilesTextField addRule:[Rules checkIfNumericWithFailureString:@"请填写数字" forTextField:blockself.carMilesTextField]];
            }
            if (blockself.model.car_miles == nil || [blockself.model.car_miles isEqualToString:@""])
                blockself.carMilesTextField.placeholder = @"未填写里程数";
            else
                blockself.carMilesTextField.text = blockself.model.car_miles;
            
            blockself.carMilesTextField.textAlignment = NSTextAlignmentRight;
            blockself.carMilesTextField.textColor = [UIColor grayColor];
            [cell addSubview:blockself.carMilesTextField];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"DetailTextCell6";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.cellHeight = 35.f;
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"组别";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            
            SellerModel *seller = [SellerModel sharedClient];
            if (seller.groups.count == 0) {
                cell.detailTextLabel.text = @"请先添加用户组";
                
            } else if (blockself.groupName == nil || [blockself.groupName isEqualToString:@""]) {
                // get user group
                NSMutableArray *userGroup = [[NSMutableArray alloc]init];
                SellerModel *seller = [SellerModel sharedClient];
                for (UserGroupModel *group in seller.groups) {
                    for (UserGroupItemModel *user in group.users) {
                        if ([user.user_id isEqualToString:blockself.user_id]) {
                            [userGroup addObject:group.name];
                        }
                    }
                }
                if (userGroup.count > 1) {
                    cell.detailTextLabel.text = @"该用户属于多个组";
                } else if (userGroup.count == 1) {
                    cell.detailTextLabel.text = [userGroup objectAtIndex:0];
                } else {
                    cell.detailTextLabel.text = @"该用户为指定组别";
                }
            } else {
                cell.detailTextLabel.text = blockself.groupName;
            }
        } whenSelected:^(NSIndexPath *indexPath) {
            if (blockself.editMode == YES) {
                SellerModel *seller = [SellerModel sharedClient];
                
                if (seller.groups.count == 0) { // jump to group add view
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"User" bundle:nil];
                    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"UserGroupAddView"];
                    controller.hidesBottomBarWhenPushed = YES;
                    [blockself.navigationController pushViewController:controller animated:YES];
                } else {
                    NSMutableArray *group = [[NSMutableArray alloc]init];
                    for (UserGroupModel *model in seller.groups) {
                        if (model.name != nil)
                            [group addObject:model.name];
                    }
                    PickerView *picker = [[PickerView alloc]initPickviewWithArray: group isHaveNavControler:false];
                    picker.delegate = blockself;
                    [picker show];
                }
            }
        }];
    }];
    
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.sectionHeight = 20;
        section.title = @"特记事项";
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell11";
            staticContentCell.cellHeight = 120.f;
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (blockself.memoTextView == nil) {
                blockself.memoTextView = [[SSTextView alloc]initWithFrame:CGRectMake(0, 0, blockself.tableView.frame.size.width, 120.f)];
                blockself.memoTextView.font = [UIFont systemFontOfSize:15.f];
                blockself.memoTextView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
                blockself.memoTextView.textColor = [UIColor grayColor];
                [blockself.memoTextView setEditable:YES];
                blockself.memoTextView.keyboardType = UIKeyboardTypeAlphabet;
                blockself.memoTextView.returnKeyType = UIReturnKeyDone;
                
            }
            if (blockself.model.memo != nil && ![blockself.model.memo isEqualToString:@""])
                blockself.memoTextView.text = blockself.model.memo;
            else
                blockself.memoTextView.placeholder = @"记录客户其他信息";
            
            
            [cell addSubview:blockself.memoTextView];
        }];
        
        
        section.sectionFooterHeight = 40.f;
        section.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, blockself.tableView.frame.size.width, 40.f)];
        // edit button
        blockself.editBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, blockself.tableView.frame.size.width, 40.f)];
        [blockself.editBtn addTarget:blockself action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (blockself.editMode == NO)
            [blockself.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        else
            [blockself.editBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        [blockself.editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        blockself.editBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
        
        blockself.editBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [section.footerView addSubview:blockself.editBtn];
    }];
    [self refreshViewStatus:self.editMode];
    // update information
    [self getUserInfo:self.user_id];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)refreshView:(UserModel *)info {
    self.model = info;
    [self.tableView reloadData];
}

- (void)refreshViewStatus:(BOOL)editable {
    self.editMode = editable;
    if (self.editMode == YES) {
        [self.nameTextField setEnabled:YES];
        self.nameTextField.textColor = [UIColor blackColor];
        
        [self.carnoTextField setEnabled:YES];
        self.carnoTextField.textColor = [UIColor blackColor];
        
        [self.carKindTextField setEnabled:YES];
        self.carKindTextField.textColor = [UIColor blackColor];
        
        [self.carMilesTextField setEnabled:YES];
        self.carMilesTextField.textColor = [UIColor blackColor];
        
        self.memoTextView.textColor = [UIColor blackColor];
        [self.memoTextView setEditable:YES];
        [self.editBtn setTitle:@"保存" forState:UIControlStateNormal];
    } else {
        [self.nameTextField setEnabled:NO];
        self.nameTextField.textColor = [UIColor lightGrayColor];
        
        [self.carnoTextField setEnabled:NO];
        self.carnoTextField.textColor = [UIColor lightGrayColor];
        
        [self.carKindTextField setEnabled:NO];
        self.carKindTextField.textColor = [UIColor lightGrayColor];
        
        [self.carMilesTextField setEnabled:NO];
        self.carMilesTextField.textColor = [UIColor lightGrayColor];
        
        self.memoTextView.textColor = [UIColor lightGrayColor];
        [self.memoTextView setEditable:NO];
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

- (void)editBtnClicked:(id)sender {
    if (self.editMode == YES) {
        [self.nameTextField setEnabled:YES];
        self.nameTextField.textColor = [UIColor blackColor];
        
        [self.carnoTextField setEnabled:YES];
        self.carnoTextField.textColor = [UIColor blackColor];
        
        [self.carKindTextField setEnabled:YES];
        self.carKindTextField.textColor = [UIColor blackColor];
        
        [self.carMilesTextField setEnabled:YES];
        self.carMilesTextField.textColor = [UIColor blackColor];
        
        self.memoTextView.textColor = [UIColor blackColor];
        [self.memoTextView setEditable:YES];
        [self.editBtn setTitle:@"保存" forState:UIControlStateNormal];
        self.editMode = NO;
    } else {
        [self submitBtnClicked:self];
    }
}

- (void)submitBtnClicked:(id)sender {
    if (!self.editMode) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户信息没有编辑" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    if ([self.nameTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户名称没有填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
        
    }
    
    if ([self.carnoTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"车牌号没有填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
        
    }
    
    if (![self.carKindTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"车系信息没有填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
        
    }
    
    if (![self.carMilesTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"车辆里程数没有填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
        
    }
    if (self.groupName == nil || [self.groupName isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有设定用户组别" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
        
    }
    
    if (self.flag == NO) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"信息填写不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
        
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"role":@"seller", @"seller_id":_seller.seller_id,  @"user_id":self.user_id}];

    [params setValue:self.carnoTextField.text forKey:@"car_no"];
    [params setValue:self.carKindTextField.text forKey:@"car_kind"];
    [params setValue:self.carMilesTextField.text forKey:@"car_miles"];
    [params setValue:self.nameTextField.text forKey:@"user_name"];
    [params setValue:self.memoTextView.text forKey:@"memo"];
    
    // set group id
    for (UserGroupModel *group in _seller.groups) {
        if (self.groupName != nil && [self.groupName isEqualToString:group.name]) {
            [params setValue:group.group_id forKey:@"group_id"];
            break;
        }
    }
    
    __block UserInfoViewController *blockself = self;
    [RCar PUT:rcar_api_seller_user modelClass:@"APIResponseModel" config:nil  params:params success:^(APIResponseModel *data) {
        if (data.api_result == APIE_OK) {
            [blockself.navigationController popViewControllerAnimated:YES];
            
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - PickerViewDelegate
-(void)pickerViewDone:(PickerView *)pickView result:(NSString *)result {
    self.groupName = result;
    [self.tableView reloadData];
}

#pragma mark - MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag != 0x500)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.tableView reloadData];
}

#pragma mark - CarSelectionViewDelegate
- (CarSelectionMode)onGetCarSelectionMode {
    return CarSelectionModeSingle;
}
- (CarSelectionType)onGetCarSelectionType {
    return CarSelectionKindWithType;
}

- (void)carSelectionCompleted:(NSArray *)result {
    if (result.count > 0) {
        self.carType = [result objectAtIndex:0];
        [self.tableView reloadData];
    }
    
}


- (void)getUserInfo:(NSString *)userid {
    if (![RCar isConnected]) {
        return;
    }
    __block UserInfoViewController *blockself = self;
    
    NSDictionary *params = @{@"role":@"seller", @"seller_id":_seller.seller_id, @"user_id":userid};
    [RCar GET:rcar_api_seller_user modelClass:@"UserModel" config:nil params:params success:^(UserModel *user) {
        if (user.api_result == APIE_OK) {
            if (user.user_id != nil)
                [blockself refreshView:user];
        } else if (user.api_result == APIE_USER_NO_EXIST) {
            [blockself refreshViewStatus:YES];
        }
        else if (user.api_result == APIE_USER_NO_EXIST) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"该用户是未注册用户，没有用户信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
        else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 0x500;
            [alert show:self];
        }
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不能连接，请检查网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }];
}

#pragma mark - UserGroupAddViewDelegate
- (void)userGroupAddCompleted:(UserGroupModel *)group {
    self.groupName = group.name;
    [self.tableView reloadData];
}

#pragma mark - MxTextFieldDelegate
-(void)mxTextFieldDidEndEditing:(MxTextField *)textField {
    self.flag = YES;
    
}

@end
