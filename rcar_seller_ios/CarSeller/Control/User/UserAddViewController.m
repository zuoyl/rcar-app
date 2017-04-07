//
//  UserAddViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "UserAddViewController.h"
#import "UserModel.h"
#import "SellerInfoModel.h"
#import "SellerModel.h"
#import "PickerView.h"
#import "UserGroupModel.h"
#import "CarKindViewController.h"
#import "SSTextView.h"

@interface UserAddViewController () <PickerViewDelegate, CarSelectionViewDelegate>
@property (nonatomic, strong) UITextField *userTextField;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *carnoTextField;
@property (nonatomic, strong) UITextField *carMilesTextField;
@property (nonatomic, strong) UITextField *groupTextField;
@property (nonatomic, strong) NSString *carType;
@property (nonatomic, strong) NSString *group;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) SSTextView *memoTextView;

@end

@implementation UserAddViewController
@synthesize groupModel;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"添加客户";
    self.hidesBottomBarWhenPushed = YES;
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    
    if (self.groupModel != nil)
        self.group = self.groupModel.name;
    
    SellerModel *seller = [SellerModel sharedClient];
    
    __block UserAddViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.sectionHeight = 5;
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell1";
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"客户名称";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            if (blockself.userTextField == nil) {
                blockself.userTextField = [[UITextField alloc]initWithFrame:CGRectMake(130, 0, 200, 35.f)];
                blockself.userTextField.contentMode = UIControlContentVerticalAlignmentCenter;
                blockself.userTextField.placeholder = @"请输入客户名称";
                blockself.userTextField.font = [UIFont systemFontOfSize:15.f];
                blockself.userTextField.keyboardType = UIKeyboardTypeAlphabet;
                blockself.userTextField.returnKeyType = UIReturnKeyDone;
            }
            [cell addSubview:blockself.userTextField];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell3";
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"客户手机号";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            
            if (blockself.phoneTextField == nil) {
                blockself.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(130, 0, 200, 35.f)];
                blockself.phoneTextField.placeholder = @"请输入联系电话";
                blockself.phoneTextField.contentMode = UIControlContentVerticalAlignmentCenter;
                blockself.phoneTextField.font = [UIFont systemFontOfSize:15.f];
                blockself.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
                blockself.phoneTextField.returnKeyType = UIReturnKeyDone;
            }
            [cell addSubview:blockself.phoneTextField];
        }];

        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell4";
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"车牌号";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            
            if (blockself.carnoTextField == nil) {
                blockself.carnoTextField = [[UITextField alloc]initWithFrame:CGRectMake(130, 0, 200, 35.f)];
                blockself.carnoTextField.contentMode = UIControlContentVerticalAlignmentCenter;
                blockself.carnoTextField.placeholder = @"请输入客户车牌号";
                blockself.carnoTextField.font = [UIFont systemFontOfSize:15.f];
                blockself.carnoTextField.keyboardType = UIKeyboardTypeAlphabet;
                blockself.carnoTextField.returnKeyType = UIReturnKeyDone;
            }
            [cell addSubview:blockself.carnoTextField];
        }];
        
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell5";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"车型";
            if (blockself.carType && ![blockself.carType isEqualToString:@""])
                cell.detailTextLabel.text = blockself.carType;
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
        } whenSelected:^(NSIndexPath *indexPath) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CarKindViewController *controller = [story instantiateViewControllerWithIdentifier:@"CarKindSelectionView"];
            controller.delegate = blockself;
            controller.rootController = blockself;
            blockself.hidesBottomBarWhenPushed = YES;
            [blockself.navigationController pushViewController:controller animated:YES];
        }];
        if (blockself.groupModel == nil) { // the group is specified
            [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                staticContentCell.reuseIdentifier = @"DetailTextCell6";
                staticContentCell.cellStyle = UITableViewCellStyleValue1;
                cell.textLabel.font = [UIFont systemFontOfSize:15.f];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (blockself.group)
                    cell.detailTextLabel.text = blockself.group;
                cell.textLabel.text = @"组别";
                cell.imageView.image = [UIImage imageNamed:@"register_user"];
                if (seller.groups.count == 0)
                    cell.detailTextLabel.text = @"请先添加用户组";
                else {
                    if (blockself.group == nil)
                        cell.detailTextLabel.text = @"点击选择用户组";
                    else
                        cell.detailTextLabel.text = blockself.group;
                }
            } whenSelected:^(NSIndexPath *indexPath) {
                if (seller.groups.count == 0) {
                    [blockself performSegueWithIdentifier:@"add_group" sender:blockself];
                    return;
                }
                SellerModel *seller = [SellerModel sharedClient];
                NSMutableArray *group = [[NSMutableArray alloc]init];
                for (UserGroupModel *model in seller.groups) {
                    if (model.name != nil)
                        [group addObject:model.name];
                }
                PickerView *picker = [[PickerView alloc]initPickviewWithArray: group isHaveNavControler:false];
                picker.delegate = blockself;
                [picker show];
            }];
        }
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell4";
            cell.textLabel.font = [UIFont systemFontOfSize:15.f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"车辆里程";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            
            if (blockself.carMilesTextField == nil) {
                blockself.carMilesTextField = [[UITextField alloc]initWithFrame:CGRectMake(130, 0, 200, 35.f)];
                blockself.carMilesTextField.contentMode = UIControlContentVerticalAlignmentCenter;
                blockself.carMilesTextField.placeholder = @"请输入车辆里程数";
                blockself.carMilesTextField.font = [UIFont systemFontOfSize:15.f];
                blockself.carMilesTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                blockself.carMilesTextField.returnKeyType = UIReturnKeyDone;
            }
            [cell addSubview:blockself.carMilesTextField];
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
                blockself.memoTextView.placeholder = @"客户记录客户其他信息";
                blockself.memoTextView.font = [UIFont systemFontOfSize:15.f];
                blockself.memoTextView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
                blockself.memoTextView.keyboardType = UIKeyboardTypeAlphabet;
                blockself.memoTextView.returnKeyType = UIReturnKeyDone;
                [blockself.memoTextView setEditable:YES];
            }
            [cell addSubview:blockself.memoTextView];
        }];
        
        
        section.sectionFooterHeight = 40.f;
        section.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, blockself.tableView.frame.size.width, 40.f)];
        blockself.submitBtn = [[UIButton alloc]initWithFrame:section.footerView.frame];
        [blockself.submitBtn addTarget:blockself action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [blockself.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [blockself.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        blockself.submitBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
        
        blockself.submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [section.footerView addSubview:blockself.submitBtn];
    }];

}

- (void)viewDidDisappear:(BOOL)animated {
   // self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)submitBtnClicked:(id)sender {
    
    if ([self.userTextField.text isEqualToString:@""] || [self.phoneTextField.text isEqualToString:@""] || self.group == nil ||[self.group isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"提示信息" message:@"用户名和手机号不能为空" delegate:self cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    SellerModel *seller = [SellerModel sharedClient];
    // check wethere the user already exist in seller.users
    for (UserModel *user in seller.users) {
        if ([user.user_id isEqualToString:self.phoneTextField.text]) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"该用户已经存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"role":@"seller", @"seller_id":seller.seller_id, @"user_name":self.userTextField.text, @"user_id":self.phoneTextField.text, @"group_name":self.group}];
    
    if (![self.carnoTextField.text isEqualToString:@""])
        [params setObject:self.carnoTextField.text forKey:@"car_no"];
    if (![self.carType isEqualToString:@""])
        [params setObject:self.carType forKey:@"car_type"];
    
    if (![self.carMilesTextField.text isEqualToString:@""])
        [params setObject:self.carnoTextField.text forKey:@"car_miles"];
    
    [params setObject:self.memoTextView.text forKey:@"memo"];
    
    __block UserAddViewController *blockself = self;
    [RCar POST:rcar_api_seller_user modelClass:@"APIResponseModel" config:nil  params:params success:^(APIResponseModel *rsp) {
        if (rsp.api_result == APIE_OK) {
            [blockself.navigationController popViewControllerAnimated:YES];
            
            // add user now
            UserModel *user = [[UserModel alloc]init];
            user.name = blockself.userTextField.text;
            user.user_id = blockself.phoneTextField.text;
            user.car_type = blockself.carType;
            user.car_no = blockself.carnoTextField.text;
            SellerModel *seller = [SellerModel sharedClient];
            [seller.users addObject:user];
            
            // insert the user in group
            for (UserGroupModel *group in seller.groups) {
                if ([group.name isEqualToString:blockself.group]) {
                    UserGroupItemModel *item = [[UserGroupItemModel alloc]init];
                    item.user_id = user.user_id;
                    item.name = user.name;
                    item.online = [NSNumber numberWithInt:0];
                    [group.users addObject:item];
                    break;
                }
            }
            if (blockself.delegate)
                [blockself.delegate userAddView:user];
            
        } else if (rsp.api_result == APIE_USER_NO_EXIST) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"该用户没有使用本软件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
            
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
    self.group = result;
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
    self.carType = [result objectAtIndex:0];
    [self.tableView reloadData];
}


@end
