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
@property (nonatomic, strong) UITextField *userTextField;
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
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"用户名";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            blockself.userTextField = [[UITextField alloc]initWithFrame:CGRectMake(110, 12, 200, 20)];
            blockself.userTextField.placeholder = @"请输入用户名称";
            [cell addSubview:blockself.userTextField];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"手机号";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            
            blockself.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(110, 12, 200, 20)];
            blockself.phoneTextField.placeholder = @"请输入注册手机号";
            [cell addSubview:blockself.phoneTextField];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"验证码";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            
            blockself.codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(110, 12, 110, 20)];
            blockself.codeTextField.placeholder = @"请输入验证码";
            [cell addSubview:blockself.codeTextField];
            
            
            blockself.codeGetBtn = [[UIButton alloc]initWithFrame:CGRectMake(220, 0, blockself.view.frame.size.width - 220, cell.frame.size.height)];
            blockself.codeGetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [blockself.codeGetBtn setTitle:@"取得验证码" forState:UIControlStateNormal];
            blockself.codeGetBtn.backgroundColor = [UIColor colorWithHex:@"2480ff"];
            [blockself.codeGetBtn addTarget:blockself action:@selector(codeGetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:blockself.codeGetBtn];
        }];
        
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"新密码";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            
            blockself.pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(110, 12, 200, 20)];
            blockself.pwdTextField.placeholder = @"请输入重置密码";
            [cell addSubview:blockself.pwdTextField];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellSelectionStyleNone;
            blockself.resetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, blockself.view.frame.size.width, cell.frame.size.height)];
            blockself.resetBtn.backgroundColor = [UIColor colorWithHex:@"2480ff"];
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

- (IBAction)codeGetBtnClicked:(id)sender {
    if ([self.phoneTextField.text isEqualToString:@""] || [self.phoneTextField.text length] != 11) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请正确输入手机号码" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneTextField.text zone:@"china" customIdentifier:@"rcar_sms" result:^(NSError *error) {
        if (error == nil) {
            // do nothing now
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"不能取得验证码，请检查网络连接" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
    }];
}

- (IBAction)resetBtnClicked:(id)sender {
    // check parameter
    if ([self.phoneTextField.text isEqualToString:@""] || [self.phoneTextField.text length] != 11) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请正确输入手机号码" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    if ([self.phoneTextField.text isEqualToString:@""] ||
        [self.pwdTextField.text isEqualToString:@""] ||
        [self.codeTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请正确填写用户信息" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    __block PwdFindViewController *blockself = self;
    
    // commit verify code at first
    [SMSSDK commitVerificationCode:self.codeTextField.text phoneNumber:self.phoneTextField.text zone:@"china" result:^(NSError *error) {
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
    NSDictionary *params = @{@"role":@"seller", @"name":self.userTextField.text, @"pwd":self.pwdTextField.text, @"mobile":self.phoneTextField.text};
   
#if 0
    [RCar callService:rcar_api_seller_reset_pwd  params:params success:^(APIResponseModel *data) {
        if (data.api_result == APIE_OK) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"重置密码成功，请返回重新登录" delegate:blockself cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        } else {
            return ;
        }
    } failure:^(NSString *errorStr) {
    }];
#endif
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}





@end
