//
//  LoginViewController.m
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-17.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "NavigationView.h"
#import "UserModel.h"
#import "DataArrayModel.h"
#import "ImageTextField.h"
#import "RegisterViewController.h"

@interface LoginViewController () <RegisterViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *forgetPwdButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) ImageTextField *nameTextField;
@property (nonatomic, strong) ImageTextField *pwdTextField;

@end

@implementation LoginViewController {
    

}

@synthesize registerButton;
@synthesize forgetPwdButton;
@synthesize loginButton;
@synthesize pwdTextField;
@synthesize nameTextField;
@synthesize indicator;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed  = YES;
    [self stopAnimating];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    //self.view.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.title = @"登录";
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
   
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    // name textfield
    self.nameTextField = [[ImageTextField alloc]initWithFrame:CGRectMake(40, 180, self.view.frame.size.width - 80, 44.f)];
    [self.nameTextField setupTextFieldWithType:ImageTextFieldTypeDefault withIconName:@"register_user"];
    self.nameTextField.font = [UIFont systemFontOfSize:17.f];
    self.nameTextField.placeholder = @"请使用用户手机号登录";
    self.nameTextField.textColor = [UIColor whiteColor];
    self.nameTextField.background = [UIImage imageNamed:@"login_button"];
    self.nameTextField.keyboardType = UIKeyboardTypePhonePad;
    self.nameTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.nameTextField];
                                                                      
    // pwd textfield
    self.pwdTextField = [[ImageTextField alloc]initWithFrame:CGRectMake(40, 224, self.view.frame.size.width - 80, 44.f)];
    [self.pwdTextField setupTextFieldWithType:ImageTextFieldTypeDefault withIconName:@"register_password"];
    self.pwdTextField.placeholder = @"用户登录密码";
    self.pwdTextField.secureTextEntry = YES;
    self.pwdTextField.font = [UIFont systemFontOfSize:17.f];
    self.pwdTextField.background = [UIImage imageNamed:@"login_button"];
    self.pwdTextField.textColor = [UIColor whiteColor];
    self.pwdTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.pwdTextField.returnKeyType = UIReturnKeyDone;
   // self.pwdTextField.delegate = self;
    self.pwdTextField.tag = 0x400;
    
    [self.view addSubview:self.pwdTextField];
    
    // login button
    self.loginButton = [[UIButton alloc]initWithFrame:CGRectMake(40.f, 320.f, self.view.frame.size.width - 80.f, 44.f)];
    self.loginButton.backgroundColor = [UIColor colorWithHex:@"2480ff"];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    self.loginButton.titleLabel.textColor = [UIColor whiteColor];
    [self.loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:self.loginButton];
    
    
    // forget button
    self.forgetPwdButton = [[UIButton alloc]initWithFrame:CGRectMake(40.f, 390.f, 60.f, 40.f)];
    self.forgetPwdButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self.forgetPwdButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetPwdButton setTitleColor:[UIColor colorWithHex:@"2480ff"] forState:UIControlStateNormal];
    
    [self.forgetPwdButton addTarget:self action:@selector(pwdFindBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.forgetPwdButton];
    
    // register button
    self.registerButton = [[UIButton alloc]initWithFrame:CGRectMake(self.loginButton.frame.origin.x +  self.loginButton.frame.size.width/2, 390.f, self.loginButton.frame.size.width/2, 40.f)];
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.registerButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.registerButton setTitle:@"用户注册" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor colorWithHex:@"2480ff"] forState:UIControlStateNormal];
    
    [self.registerButton addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (LoginViewController*) initWithDelegate:(id)sender tag:(NSInteger)tag{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *viewController = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    viewController.delegate = sender;
    viewController.tag = tag;
    return viewController;
}

- (void)hideKeyboard:(UITapGestureRecognizer *)gesture{
    [nameTextField resignFirstResponder];
    [pwdTextField resignFirstResponder];
}

- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //if (buttonIndex == 0) { // cancel
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.delegate onLoginFailed];
    //} else { // retry
    //    [self performSelector:@selector(doLogin)];
    //}
}

- (void)handleLoginError {
    MxAlertView *loginAlertView = [[MxAlertView alloc] initWithTitle:@"登陆错误" message:@"用户名或密码不正确" delegate:self cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
    
    [loginAlertView show:self];
}

- (void)loginButtonClicked:(id)sender {
    if ([self.nameTextField.text length] == 0 ||
        [self.pwdTextField.text length] == 0) {
        MxAlertView *loginAlertView = [[MxAlertView alloc] initWithTitle:@"登陆错误" message:@"用户名和密码不能为空" delegate:self cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        
        [loginAlertView show:self];
        return;
    }
    
    if (![Reachability isEnableNetwork]) {
        [CommonUtil showHintHUD:No_Network_Connection inView:self.view];
        return;
    }
    [self loginUser:self.nameTextField.text pwd:self.pwdTextField.text];
}

- (void)pwdFindBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"show_pwd_find_view" sender:self];
}

- (void)registerBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"show_register_view" sender:self];
}

- (void)loginUser:(NSString *)user_id pwd:(NSString *)pwd {
    UserModel *user = [UserModel sharedClient];
    user.user_id = user_id;
    [self startAnimating];
    
    NSString *userId = [NSString stringWithString:[user getPushUserId]];
    NSString *channelId = [NSString stringWithString:[user getPushChannelId]];
    
    NSDictionary *param = @{@"role":@"user", @"user_id":user_id, @"pwd":pwd, @"device_type":@"ios", @"push_user_id":userId, @"push_channel_id":channelId};
    [RCar POST:rcar_api_user_session modelClass:@"APIResponseModel" config:nil params:param success:^(APIResponseModel *data) {
        if (data.api_result == APIE_OK) {
            [user setLoginStatus:true];
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate onLoginSuccessed:self.tag];
        } else {
            [self handleLoginError];
        }
        [self stopAnimating];
        
    }failure:^(NSString *errorStr) {
        //NSLog(@"log error: %@", errorStr);
        //[self handleLoginError];
        [self stopAnimating];
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
}

- (void)startAnimating {
    [self.indicator startAnimating];
    loginButton.enabled = NO;
    registerButton.enabled = NO;
    forgetPwdButton.enabled = NO;
}

- (void)stopAnimating {
    [self.indicator stopAnimating];
    loginButton.enabled = YES;
    registerButton.enabled = YES;
    forgetPwdButton.enabled = YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *controller = segue.destinationViewController;
    controller.hidesBottomBarWhenPushed = YES;
    
    if ([segue.destinationViewController respondsToSelector:@selector(setDelegate:)])
       [segue.destinationViewController setValue:self forKey:@"delegate"];
}

#pragma mark - RegisterViewDelegate
- (void)registerView:(NSString *)user_id pwd:(NSString *)pwd {
    [self loginUser:user_id pwd:pwd];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 0x400) {
        [self loginButtonClicked:self];
    }
}


@end
