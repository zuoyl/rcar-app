//
//  SellerServiceUserInfoViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 17/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerServiceUserInfoViewController.h"

@interface SellerServiceUserInfoViewController ()

@end

@implementation SellerServiceUserInfoViewController
@synthesize userHintLabel;
@synthesize model;
@synthesize userNameText;
@synthesize telephoneText;
@synthesize carnoText;
@synthesize otherText;
@synthesize loginBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.otherText.text = @"请输入其他备注信息";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    
    UserModel *user = [UserModel sharedClient];
    if ([user isLogin] == true) {
        userHintLabel.text = @"您已经登录,可以直接选择【继续】进行下一步";
        [loginBtn setHidden:YES];
    } else {
        self.hidesBottomBarWhenPushed = YES;
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *controller = [segue destinationViewController];
    if ([controller respondsToSelector:@selector(setMode:)]) {
        [controller setValue:self.model forKey:@"model"];
    }
}

- (IBAction)loginBtnTaped:(id)sender {
    LoginViewController *loginController = [LoginViewController initWithDelegate:self tag:0];
    [self.navigationController pushViewController:loginController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
}

- (IBAction)continueBtnTaped:(id)sender {
    if (self.userNameText.text == nil ||
         self.telephoneText.text == nil){
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"信息提示" message:@"用户名或电话号码没有填写" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
    self.model.name = self.userNameText.text;
    self.model.telephone = self.telephoneText.text;
    self.model.desc = self.otherText.text;
    self.model.carno = self.carnoText.text;
    
    [self performSegueWithIdentifier:@"seller_contact" sender:self];
}

- (void)onLoginSuccessed:(NSInteger)tag {
    UserModel *user = [UserModel sharedClient];
    userHintLabel.text = @"您已经登录,可以直接选择【继续】进行下一步";
    [loginBtn setHidden:YES];
    self.userNameText.text = user.info.user_name;
    self.telephoneText.text = user.user_id;
   // self.carnoText.text = user.info.cars;//
}
- (void)onLoginFailed :(NSInteger)tag{
    
}

@end
