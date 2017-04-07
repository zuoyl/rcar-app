//
//  PwdFindViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 30/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "PwdFindViewController.h"
#import <SMSSDK.h>

@interface PwdFindViewController () <UIActionSheetDelegate>
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, strong) UIButton *codeGetBtn;

@end

@implementation PwdFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"找回密码";
    self.hidesBottomBarWhenPushed = YES;
    //self.navigationItem.backBarButtonItem = nil;
    
    __block PwdFindViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.sectionHeight = 5;
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell1";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"手机号";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            
            blockself.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(110, 0, 200, 35.f)];
            blockself.phoneTextField.placeholder = @"请输入注册手机号";
            blockself.phoneTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.phoneTextField.font = [UIFont systemFontOfSize:15.f];
            blockself.phoneTextField.keyboardType = UIKeyboardTypeNamePhonePad;
            blockself.phoneTextField.returnKeyType = UIReturnKeyDone;
            [cell addSubview:blockself.phoneTextField];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell2";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"验证码";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            
            blockself.codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(110, 0, 110, 35.f)];
            blockself.codeTextField.placeholder = @"请输入验证码";
            blockself.codeTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.codeTextField.font = [UIFont systemFontOfSize:15.f];
            blockself.codeTextField.keyboardType = UIKeyboardTypeNamePhonePad;
            blockself.codeTextField.returnKeyType = UIReturnKeyDone;
            [cell addSubview:blockself.codeTextField];
            
            
            blockself.codeGetBtn = [[UIButton alloc]initWithFrame:CGRectMake(blockself.view.frame.size.width - 120, 0, 120, 35.f)];
            blockself.codeGetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [blockself.codeGetBtn setTitle:@"取得验证码" forState:UIControlStateNormal];
            blockself.codeGetBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
            [blockself.codeGetBtn addTarget:blockself action:@selector(codeGetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:blockself.codeGetBtn];
        }];
        
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell3";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"新密码";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            
            blockself.pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(110, 0, 200, 35.f)];
            blockself.pwdTextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.pwdTextField.placeholder = @"请输入重置密码";
            blockself.pwdTextField.font = [UIFont systemFontOfSize:15.f];
            blockself.pwdTextField.keyboardType = UIKeyboardTypeASCIICapable;
            blockself.pwdTextField.returnKeyType = UIReturnKeyDone;
            [cell addSubview:blockself.pwdTextField];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell4";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellSelectionStyleNone;
            blockself.resetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, blockself.view.frame.size.width, 35.f)];
            blockself.resetBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
            [blockself.resetBtn setTitle:@"重置密码" forState:UIControlStateNormal];
            [blockself.resetBtn addTarget:blockself action:@selector(resetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:blockself.resetBtn];
          
        }];
    }];
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

- (void)codeGetBtnClicked:(id)sender {
    if ([self.phoneTextField.text isEqualToString:@""] || [self.phoneTextField.text length] != 11) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请正确输入手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
   // __block PwdFindViewController *blockself = self;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneTextField.text zone:@"86" customIdentifier:@"rcar_sms"  result:^(NSError *error) {
        if (error == nil) {
            // do nothing now
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"不能取得验证码，请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
    }];
}

- (void)resetBtnClicked:(id)sender {
    // check parameter
    if ([self.phoneTextField.text isEqualToString:@""] || [self.phoneTextField.text length] != 11) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请正确输入手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    if ([self.pwdTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"密码没有填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    if ([self.codeTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"验证码没有填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    __block PwdFindViewController *blockself = self;
    
    // commit verify code at first
    [SMSSDK commitVerificationCode:self.codeTextField.text phoneNumber:self.phoneTextField.text zone:@"86" result:^(NSError *error) {
        if (error == nil) {
            [blockself resetSellerPassword];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"验证码错误，请正确填写或重新取得验证码" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show:self];
            return ;
        }
    }];
}

- (void)resetSellerPassword {
    
    __block PwdFindViewController *blockself = self;
    NSDictionary *params = @{@"role":@"seller", @"seller_id":self.phoneTextField.text, @"pwd":self.pwdTextField.text, @"mobile":self.phoneTextField.text};
    
    [RCar POST:rcar_api_seller_pwd  modelClass:@"APIResponseModel" config:nil  params:params success:^(APIResponseModel *data) {
        if (data.api_result == APIE_OK) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"重置密码成功，请返回重新登录" delegate:blockself cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        } else {
            return ;
        }
    } failure:^(NSString *errorStr) {
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}




@end
