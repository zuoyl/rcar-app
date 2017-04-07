//
//  RegisterViewController.m
//  CarUser
//
//  Created by huozj on 1/6/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//



#import "PwdFindViewController.h"
#import "UserModel.h"
#import "DataArrayModel.h"
#import <SMS_SDK/SMS_SDK.h>


@implementation PwdFindViewController {
    
}

@synthesize mobileText;
@synthesize pwdText;
@synthesize confirmPwdText;
@synthesize codeText;
@synthesize activity;
@synthesize resetBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self stopAnimating];
    self.navigationItem.title = @"重置密码";
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideKeyboard:(UITapGestureRecognizer *)gesture{
    [mobileText resignFirstResponder];
    [pwdText resignFirstResponder];
    [confirmPwdText resignFirstResponder];
    [codeText resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)codeButtonClicked:(id)sender {
    if ([self.mobileText.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请填写手机号码" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([self.mobileText.text length] != 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请正确填写手机号码" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    // __block PwdFindViewController *blockself = self;
    [SMS_SDK getVerifyCodeByPhoneNumber:self.mobileText.text AndZone:@"china"  result:^(enum SMS_GetVerifyCodeResponseState state) {
        if (state == SMS_ResponseStateGetVerifyCodeSuccess) {
            // do nothing now
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"不能取得验证码，请检查网络连接" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }];
    
}

- (IBAction)resetButtonClicked:(id)sender {
    // check parameters
    if ([self.pwdText.text isEqualToString:@""] ||
        [self.confirmPwdText.text isEqualToString:@""] ||
        [self.codeText.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"信息填写不全，请正确填写信息" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([self.pwdText.text isEqualToString:self.confirmPwdText.text] == false) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"密码和确认密码不一致，请请重新填写" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self startAnimating];
    __block PwdFindViewController *blockself = self;
    
    // commit verify code at first
    [SMS_SDK commitVerifyCode:self.codeText.text result:^(enum SMS_ResponseState state) {
        if (state == SMS_ResponseStateSuccess) {
            [blockself doReset];
        } else {
            [self stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"验证码错误，请正确填写或重新取得验证码" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
    }];
}

- (void)doReset {
    NSDictionary *params = @{@"role":@"usr", @"usr_id":self.mobileText.text, @"pwd":self.pwdText.text, @"code":self.codeText.text};
    
    __block PwdFindViewController *blockself = self;
    [RCar callService:rcar_api_usr_register modelClass:@"APIResponseModel" config:nil params:params success:^(APIResponseModel *data) {
        [self stopAnimating];
        if (data.api_result == APIE_OK) {
            [blockself.navigationController popToRootViewControllerAnimated:true];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"通信失败,请检查网络连接" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show];
            return ;
            
        }
    } failure:^(NSString *errorStr) {
        [self stopAnimating];
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
    
}

- (void)startAnimating {
    [self.activity startAnimating];
    self.resetBtn.enabled = NO;
}

- (void)stopAnimating {
    [self.activity stopAnimating];
    self.resetBtn.enabled = YES;
}

@end

