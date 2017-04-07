//
//  RegisterViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 29/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserModel.h"
#import <SMSSDK.h>

enum TAG_REGISTER_TEXTFIELD{
    
    Tag_AccountTextField = 100,        //用户名
    Tag_TempPasswordTextField,    //登录密码
    Tag_ConfirmPasswordTextField, //确认登录密码
    Tag_MobileTextField,        //推荐人
    Tag_VerifyCodeTextField,
};

#pragma mark - Register Label Tag

#pragma mark - protocol Btn Tag 协议有关的btn的tag值
enum TAG_PROTOCOL_BUTTON{
    
    Tag_isReadButton = 200,   //是否已阅读
    Tag_servicesButton,       //服务协议
    Tag_privacyButton         //隐私协议
};


@interface RegisterViewController () <MxAlertViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *pwd1TextField;
@property (nonatomic, strong) UITextField *pwd2TextField;
@property (nonatomic, strong) UITextField *vcodeTextField;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIButton *codeGetBtn;
@end

@implementation RegisterViewController {
    BOOL _isRead;
    UIButton *_codegenBtn;
}

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"用户注册";
    //[self.registerBtn setEnabled:NO];
    
    __block RegisterViewController *blockself = self;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.sectionHeight = 5;
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell1";
            staticContentCell.cellHeight = 35.f;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"手机号";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            if (blockself.nameTextField == nil)
                blockself.nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(110, 0, 200, 35.f)];
            blockself.nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            blockself.nameTextField.placeholder = @"请输入用户手机号";
            blockself.nameTextField.tag = Tag_AccountTextField;
            blockself.nameTextField.delegate = blockself;
            blockself.nameTextField.keyboardType = UIKeyboardTypeNamePhonePad;
            blockself.nameTextField.returnKeyType = UIReturnKeyDone;
            [cell addSubview:blockself.nameTextField];
        }];
        section.sectionFooterHeight = 25.f;
        section.footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, blockself.view.frame.size.width, section.sectionFooterHeight)];
        section.footerView.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 0.f, 300.f, section.sectionFooterHeight)];
        label.text = @"密码请使用6~20位字符，可包含英文、数字和“_”";
        label.contentMode = UIControlContentVerticalAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13.f];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        [section.footerView addSubview:label];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.sectionHeight = 5;
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell2";
            staticContentCell.cellHeight = 35.f;

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"密码";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            blockself.pwd1TextField = [[UITextField alloc]initWithFrame:CGRectMake(140, 0, blockself.view.frame.size.width - 140, 35)];
            if (blockself.pwd1TextField == nil)
                blockself.pwd1TextField.contentMode = UIControlContentVerticalAlignmentCenter;
            blockself.pwd1TextField.placeholder = @"请输入密码";
            blockself.pwd1TextField.returnKeyType = UIReturnKeyDone;
            blockself.pwd1TextField.secureTextEntry = YES;
            blockself.pwd1TextField.delegate = blockself;
            blockself.pwd1TextField.tag = Tag_TempPasswordTextField;
            blockself.pwd1TextField.keyboardType = UIKeyboardTypeASCIICapable;
            blockself.pwd1TextField.returnKeyType = UIReturnKeyDone;
            [cell addSubview:blockself.pwd1TextField];
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell3";
            staticContentCell.cellHeight = 35.f;

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"确认密码";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            if (blockself.pwd2TextField == nil)
                blockself.pwd2TextField = [[UITextField alloc]initWithFrame:CGRectMake(140, 0, blockself.view.frame.size.width - 140, 35)];
            blockself.pwd2TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            blockself.pwd2TextField.placeholder = @"请输入确认密码";
            blockself.pwd2TextField.returnKeyType = UIReturnKeyDone;
            blockself.pwd2TextField.secureTextEntry = YES;
            blockself.pwd2TextField.delegate = blockself;
            blockself.pwd2TextField.tag = Tag_ConfirmPasswordTextField;
            blockself.pwd2TextField.keyboardType = UIKeyboardTypeASCIICapable;
            blockself.pwd2TextField.returnKeyType = UIReturnKeyDone;
            [cell addSubview:blockself.pwd2TextField];
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"UIControlCell4";
            staticContentCell.cellHeight = 35.f;

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"验证码";
            cell.imageView.image = [UIImage imageNamed:@"register_user"];
            if (blockself.vcodeTextField == nil)
            blockself.vcodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(140, 0, blockself.view.frame.size.width - 140, 35)];
            blockself.vcodeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            blockself.vcodeTextField.placeholder = @"请输入确认密码";
            blockself.vcodeTextField.returnKeyType = UIReturnKeyDone;
            blockself.vcodeTextField.secureTextEntry = YES;
            blockself.vcodeTextField.delegate = blockself;
            blockself.vcodeTextField.tag = Tag_VerifyCodeTextField;
            blockself.vcodeTextField.keyboardType = UIKeyboardTypeASCIICapable;
            blockself.vcodeTextField.returnKeyType = UIReturnKeyDone;
            [cell addSubview:blockself.vcodeTextField];
            
            blockself.codeGetBtn = [[UIButton alloc]initWithFrame:CGRectMake(280, 0.f, blockself.view.frame.size.width - 280.f, 35.f)];
            blockself.codeGetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            blockself.codeGetBtn.titleLabel.textColor = [UIColor whiteColor];
            blockself.codeGetBtn.backgroundColor = [UIColor colorWithHex:@"2480ff"];
            [blockself.codeGetBtn setTitle:@"取得验证码" forState:UIControlStateNormal];
            [blockself.codeGetBtn addTarget:blockself action:@selector(codeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:blockself.codeGetBtn];

        }];
        section.sectionFooterHeight = 25.f;
        section.footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, blockself.view.frame.size.width, section.sectionFooterHeight)];
        section.footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *isReadBtn = [[UIButton alloc]initWithFrame:CGRectMake(10.f, 0.f, 21.f, section.sectionFooterHeight)];
        [isReadBtn setImage:[UIImage imageNamed:@"isRead_waiting_selectButton"] forState:UIControlStateNormal];
        [isReadBtn addTarget:blockself action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        isReadBtn.tag = Tag_isReadButton;
        [section.footerView addSubview:isReadBtn];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(35.f, 0.f, 120.f, section.sectionFooterHeight)];
        label1.text = @"我已阅读并同意";
        label1.contentMode = UIControlContentVerticalAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:13.f];
        label1.textColor = [UIColor blackColor];
        label1.backgroundColor = [UIColor clearColor];
        label1.textAlignment = NSTextAlignmentLeft;
        [section.footerView addSubview:label1];
        
        
        UIButton *servicesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        servicesBtn.frame = CGRectMake(135.f, 0.f, 60.f, section.sectionFooterHeight);
        [servicesBtn setTitle:@"服务协议" forState:UIControlStateNormal];
        [servicesBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        servicesBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [servicesBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [servicesBtn addTarget:blockself action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        servicesBtn.tag = Tag_servicesButton;
        [section.footerView addSubview:servicesBtn];
        
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(195.f, 0.f, 15.f, section.sectionFooterHeight)];
        label2.text = @"和";
        label2.font = [UIFont systemFontOfSize:13.f];
        label2.textColor = [UIColor blackColor];
        label2.backgroundColor = [UIColor clearColor];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.contentMode = UIControlContentVerticalAlignmentCenter;
        [section.footerView addSubview:label2];
        
        UIButton *privacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        privacyBtn.frame = CGRectMake(215.f, 0.f, 100.f, section.sectionFooterHeight);
        [privacyBtn setTitle:@"隐私协议" forState:UIControlStateNormal];
        [privacyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        privacyBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [privacyBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [privacyBtn addTarget:blockself action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        privacyBtn.tag = Tag_privacyButton;
        [section.footerView addSubview:privacyBtn];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.sectionHeaderHight = 44.f;
        
        blockself.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, blockself.view.frame.size.width, section.sectionHeaderHight)];;
        [blockself.submitBtn addTarget:blockself action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        blockself.submitBtn.backgroundColor = [UIColor colorWithHex:@"2480ff"];
        [blockself.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [blockself.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        blockself.submitBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [blockself.submitBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        section.headerView = blockself.submitBtn;
    }];
     
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)codeButtonClicked:(id)sender {
    if ([self.nameTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有填写手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    if ([self.nameTextField.text length] != 11) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"手机号码填写不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
    [self.codeGetBtn setEnabled:NO];
    [self.codeGetBtn setTitle:@"正在取验证码" forState:UIControlStateNormal];
    
    __block RegisterViewController *blockself = self;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.nameTextField.text  zone:@"86" customIdentifier:@"rcar_sms"  result:^(NSError *error) {
        [blockself.codeGetBtn setTitle:@"取得验证码" forState:UIControlStateNormal];
        [blockself.codeGetBtn setEnabled:YES];
        if (error == nil) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"验证码已发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"不能取得验证码，请检查网络连接" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
    }];
}

- (void)registerUser {
    NSString *password = self.pwd1TextField.text;
    NSString *mobile = self.nameTextField.text;
    
    // update seller_id
    NSDictionary *params = @{@"role":@"user", @"mobile":mobile, @"pwd":password};
    
    __block RegisterViewController *blockself = self;
    [RCar POST:rcar_api_user modelClass:nil config:nil params:params success:^(NSDictionary * data) {
        NSString * result = [data objectForKey:@"api_result"];
        if (result.integerValue == APIE_OK) {
            NSString *userId = [data objectForKey:@"user_id"];
            UserModel *user = [UserModel sharedClient];
            [user setLoginStatus:YES];
            user.user_id = userId;
            if (blockself.delegate != nil)
                [blockself.delegate registerView:userId pwd:blockself.pwd2TextField.text];
            
            [blockself.navigationController popViewControllerAnimated:YES];
        } else if (result.integerValue == APIE_USER_ALREADY_EXIST) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户名已存在，请重新选择用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return ;
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

#pragma mark - UIButtonClicked Method
- (void)buttonClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case Tag_isReadButton:
            //是否阅读协议
            if (_isRead) {
                [btn setImage:[UIImage imageNamed:@"isRead_waiting_selectButton"] forState:UIControlStateNormal];
                _isRead = NO;
            }else{
                [btn setImage:[UIImage imageNamed:@"isRead_selectedButton"] forState:UIControlStateNormal];
                _isRead = YES;
            }
            break;
        case Tag_servicesButton:
            //服务协议
            //[Utils alertTitle:@"提示" message:@"您点击了服务协议" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
            break;
        case Tag_privacyButton:
            //隐私协议
            //[Utils alertTitle:@"提示" message:@"您点击了隐私协议" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
            break;
        default:
            break;
    }
    
}

#pragma mark - RegisterBtnClicked Method
- (void)registerBtnClicked:(id)sender{
    if (!_isRead) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请勾选阅读协议选项框" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
#if 0
    if ([self.vcodeTextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请填写验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
#endif
    
    if (![self checkValidityTextField])
            return;
    
#if 0
    __block RegisterViewController *blockself = self;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.vcodeTextField.text zone:@"china" customIdentifier:@"rcar_sms" result:^(NSError *error) {
        if (error == nil) {
            [blockself registerUser];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"验证码错误，请正确填写或重新取得验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return ;
        }
    }];
#else
    [self registerUser];
    
#endif
}

#pragma mark checkValidityTextField Null
- (BOOL)checkValidityTextField {
    // check mobie
    if ([self.nameTextField.text isEqualToString:@""] ||([self.nameTextField.text length] != 11)) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请填写手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if ([self.nameTextField.text length] != 11) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"手机号码填写不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    
    // check password
    if ([self.pwd1TextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请填写注册密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    
    if ([self.pwd2TextField.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请填写确认密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if ([self.pwd1TextField.text length] < 6 || [self.pwd2TextField.text length] < 6) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"密码位数小于6位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    if (![self.pwd1TextField.text isEqualToString:self.pwd2TextField.text]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show:self];
        return false;
    }
    
    return true;
}

#pragma mark - UITextFieldDelegate Method
- (void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case Tag_AccountTextField:
            if ([textField.text length] != 11) {
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"手机号码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show:self];
                return;
            }
            break;
        case Tag_TempPasswordTextField:
            if ([textField.text length] < 6) {
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户密码小于6位！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alert show:self];
                return;
            }
            break;
        case Tag_ConfirmPasswordTextField:
            if ([textField.text length] > 0) {
                if (![self.pwd1TextField.text isEqualToString:self.pwd2TextField.text]) {
                    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                    [alert show:self];
                    return;
                }
            } else if ([textField.text isEqualToString:@""]) {
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请填写确认密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alert show:self];
                return;
            }
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - touchMethod
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    [self allEditActionsResignFirstResponder];
}

#pragma mark - PrivateMethod
- (void)allEditActionsResignFirstResponder{
    
    //邮箱
    [[self.view viewWithTag:Tag_MobileTextField] resignFirstResponder];
    //用户名
    [[self.view viewWithTag:Tag_AccountTextField] resignFirstResponder];
    //temp密码
    [[self.view viewWithTag:Tag_TempPasswordTextField] resignFirstResponder];
    //确认密码
    [[self.view viewWithTag:Tag_ConfirmPasswordTextField] resignFirstResponder];
}



@end
