//
//  RegisterViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 29/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "Register1ViewController.h"
#import "RegisterModel.h"
#import "SellerModel.h"
#import "SMSSDK.h"
#import "RegisterModel.h"

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


@interface Register1ViewController () <MxAlertViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation Register1ViewController {
    BOOL _isRead;
    UIButton *_codegenBtn;
    RegisterModel *_registerModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商户注册(1/2)";
    //[self.registerBtn setEnabled:NO];
    //self.tableView.style = UITableViewStyleGrouped;
    
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
    _registerModel.step = RegisterModelStep1;
    
    MxAlertView *alert = [[MxAlertView alloc] initWithTitle:@"提示信息" message:@"需注册商户后才能够使用" delegate:self cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
    [alert show:self];
    return;
    
    
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
#if 0
    [_codegenBtn setEnabled:NO];
    [_codegenBtn setTitle:@"正在取得验证码" forState:UIControlStateNormal];
    [_codegenBtn setBackgroundImage:[UIImage imageNamed:@"register_btn"] forState:UIControlStateNormal];
    
    NSString *mobile = [(UITextField *)[self.view viewWithTag:Tag_MobileTextField] text];
    __block Register1ViewController *blockself = self;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:mobile zone:@"86" customIdentifier:nil result:^(NSError *error) {
        [_codegenBtn setTitle:@"取得验证码" forState:UIControlStateNormal];
        [_codegenBtn setEnabled:YES];
        if (error == nil) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请输入验证码后点击注册" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"不能取得验证码，请检查网络连接" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
    }];
#endif
}

- (void)registerButtonClicked:(id)sender {
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return 1;
    else if (section == 1) return 2;
    else if (section == 2)return 1;
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    if (indexPath.section == 0){ // user name
        cell.imageView.image = [UIImage imageNamed:@"register_user"];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 0.f, 220.f, height)];
        textField.contentMode = UIControlContentVerticalAlignmentCenter;
        textField.tag = Tag_MobileTextField;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"手机号码,必填";
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
        textField.returnKeyType = UIReturnKeyDone;
        textField.font = [UIFont systemFontOfSize:15.f];
        [cell addSubview:textField];
    
    } else if (indexPath.section == 1){ // password
        
        if (indexPath.row == 0) {
            
            cell.imageView.image = [UIImage imageNamed:@"register_password"];
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 0.f, 220.f, height)];
            textField.tag = Tag_TempPasswordTextField;
            textField.contentMode = UIControlContentVerticalAlignmentCenter;
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
            textField.delegate = self;
            textField.placeholder = @"密码,必填";
            textField.font = [UIFont systemFontOfSize:15.f];
            textField.keyboardType = UIKeyboardTypeAlphabet;
            textField.returnKeyType = UIReturnKeyDone;
            [cell addSubview:textField];
            
        }else if (indexPath.row == 1){
            
            cell.imageView.image = [UIImage imageNamed:@"register_password"];
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 0.f, 220.f, height)];
            textField.contentMode = UIControlContentVerticalAlignmentCenter;
            
            textField.tag = Tag_ConfirmPasswordTextField;
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
            textField.delegate = self;
            textField.placeholder = @"确认密码,必填";
            textField.font = [UIFont systemFontOfSize:15.f];
            textField.keyboardType = UIKeyboardTypeAlphabet;
            textField.returnKeyType = UIReturnKeyDone;
            [cell addSubview:textField];
        }
        
    } else if (indexPath.section == 2){ // verify code
        cell.imageView.image = [UIImage imageNamed:@"register_password"];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 0.f, 100.f, height)];
        textField.contentMode = UIControlContentVerticalAlignmentCenter;
        
        textField.tag = Tag_VerifyCodeTextField;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"验证码,必填";
        textField.font = [UIFont systemFontOfSize:15.f];
        textField.keyboardType = UIKeyboardTypeAlphabet;
        textField.returnKeyType = UIReturnKeyDone;
        
        [cell addSubview:textField];
        
        _codegenBtn = [[UIButton alloc]initWithFrame:CGRectMake(200.f, 0.f, cell.frame.size.width - 120, 35.f)];
        _codegenBtn.backgroundColor = [UIColor blueColor];
        _codegenBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _codegenBtn.titleLabel.textColor = [UIColor whiteColor];
        _codegenBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
        [_codegenBtn setTitle:@"取得验证码" forState:UIControlStateNormal];
        [_codegenBtn addTarget:self action:@selector(codeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_codegenBtn];
        
    } else if (indexPath.section == 3){
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CGFloat height = [self tableView:self.tableView heightForFooterInSection:section];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.tableView.frame.size.width, height)];
    footerView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    
    if (section == 0){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 0.f, self.view.frame.size.width, height)];
        label.contentMode = UIControlContentVerticalAlignmentCenter;
        label.text = @"注册后不可更改，请使用正确的手机号码”";
        label.font = [UIFont systemFontOfSize:12.f];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        [footerView addSubview:label];
        
    } else if (section == 1){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 0.f, self.view.frame.size.width, height)];
        label.contentMode = UIControlContentVerticalAlignmentCenter;
        label.text = @"密码为6位字符以上，可包含数字、字母（区分大小写）";
        label.font = [UIFont systemFontOfSize:12.f];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        [footerView addSubview:label];
  
    } else if (section == 2){
        UIButton *isReadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        isReadBtn.contentMode = UIControlContentVerticalAlignmentCenter;
        isReadBtn.frame = CGRectMake(10.f, 0.f, height, height);
        [isReadBtn setImage:[UIImage imageNamed:@"isRead_waiting_selectButton"] forState:UIControlStateNormal];
        [isReadBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        isReadBtn.tag = Tag_isReadButton;
        [footerView addSubview:isReadBtn];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(35.f, 0.f, 100.f, height)];
        label1.contentMode = UIControlContentVerticalAlignmentCenter;
        label1.text = @"我已阅读并同意";
        label1.font = [UIFont systemFontOfSize:12.f];
        label1.textColor = [UIColor blackColor];
        label1.backgroundColor = [UIColor clearColor];
        label1.textAlignment = NSTextAlignmentLeft;
        [footerView addSubview:label1];
        
        
        UIButton *servicesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        servicesBtn.contentMode = UIControlContentVerticalAlignmentCenter;
        servicesBtn.frame = CGRectMake(125.f, 0.f, 50.f, height);
        [servicesBtn setTitle:@"服务协议" forState:UIControlStateNormal];
        [servicesBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        servicesBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [servicesBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [servicesBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        servicesBtn.tag = Tag_servicesButton;
        [footerView addSubview:servicesBtn];
        
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(175.f, 0.f, 15.f, height)];
        label2.contentMode = UIControlContentVerticalAlignmentCenter;
        label2.text = @"和";
        label2.font = [UIFont systemFontOfSize:12.f];
        label2.textColor = [UIColor blackColor];
        label2.backgroundColor = [UIColor clearColor];
        label2.textAlignment = NSTextAlignmentLeft;
        [footerView addSubview:label2];
        
        UIButton *privacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        privacyBtn.contentMode = UIControlContentVerticalAlignmentCenter;
        privacyBtn.frame = CGRectMake(190.f, 0.f, 100.f, height);
        [privacyBtn setTitle:@"隐私协议" forState:UIControlStateNormal];
        [privacyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        privacyBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [privacyBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [privacyBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        privacyBtn.tag = Tag_privacyButton;
        [footerView addSubview:privacyBtn];
    } else {
        self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
        self.submitBtn.backgroundColor = [UIColor colorWithHex:@"509400"];
        [self.submitBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [self.submitBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [footerView addSubview:self.submitBtn];
        
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  35.f;
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    if (section  == 3) return 35.f;
    else return 25.f;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
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
    
    if (![self checkValidityTextField])
        return;

    if (!_isRead) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请勾选阅读协议选项框" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
    
    if (![RCar isConnected]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不能连接,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
#if 0
    NSString *code = [(UITextField *)[self.view viewWithTag:Tag_VerifyCodeTextField] text];
    
    __block Register1ViewController *blockself = self;
    // commit verify code at first
    [SMSSDK commitVerificationCode:code phoneNumber:code zone:@"86" result:^(NSError *error) {
        if (error == nil) {
            [blockself registerSellerForNext];
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"验证码错误，请正确填写或重新取得验证码" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show:self];
            return ;
        }
    }];
#else
    [self registerSellerForNext];
#endif

    
}

#pragma mark checkValidityTextField Null
- (BOOL)checkValidityTextField {
    if ([(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] isEqualToString:@""]) {
        
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户密码不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show:self];
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text] isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户确认密码不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show:self];

        return NO;
    }
    
    return YES;
    
}

#pragma mark - UITextFieldDelegate Method

- (void)textFieldDidBeginEditing:(UITextField *)textField{
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
            
        case Tag_MobileTextField:
            if ([textField text] != nil && [[textField text] length] != 11) {
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"手机号码不正确" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alert show:self];
            }
            break;
        case Tag_TempPasswordTextField:
            if ([textField text] != nil && [[textField text] length]!= 0) {
                if ([[textField text] length] < 6) {
                    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户密码小于6位！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                    [alert show:self];
                    
                }
            }
            break;
        case Tag_ConfirmPasswordTextField:
            if ([[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] length] !=0 && ([textField text]!= nil && [[textField text] length]!= 0)) {
                
                if (![[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] isEqualToString:[textField text]]) {
                    if ([[textField text] length] < 6) {
                        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                        [alert show:self];
                        
                    }
                    
                }
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


- (void)registerSellerForNext {
    _registerModel.pwd = [(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text];
    _registerModel.mobile = [(UITextField *)[self.view viewWithTag:Tag_MobileTextField] text];
    _registerModel.name = [(UITextField *)[self.view viewWithTag:Tag_AccountTextField] text];
    _registerModel.seller_id = _registerModel.mobile;
    
    
    NSDictionary *params = @{@"role":@"seller", @"mobile":_registerModel.mobile, @"check":@"yes"};
    
    __block Register1ViewController *blockself = self;
    [RCar POST:rcar_api_seller modelClass:nil config:nil params:params success:^(NSDictionary * data) {
        NSString *result = [data objectForKey:@"api_reuslt"];
        if (result.integerValue == APIE_OK) {
            [blockself performSegueWithIdentifier:@"register_detail" sender:blockself];
            
        } else if (result.integerValue == APIE_SELLER_ALREADY_EXIST) {
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



@end
