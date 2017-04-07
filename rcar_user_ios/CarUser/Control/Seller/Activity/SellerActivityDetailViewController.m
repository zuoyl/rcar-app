//
//  SellerActivityViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 30/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerActivityDetailViewController.h"
#import "SSTextView.h"
#import "SellerInfoViewController.h"
#import "LoginViewController.h"

@interface SellerActivityDetailViewController ()<MxAlertViewDelegate, LoginViewDelegate>

@end

@implementation SellerActivityDetailViewController
@synthesize model;
@synthesize tableView;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"活动详细";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


enum {
    SectionActivity,
    SectionMax,
};

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return SectionMax;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == SectionActivity) return 4;
    else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionActivity && indexPath.row == 3) return 160.f;
    else return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == SectionActivity) return @"活动信息";
    else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = nil;
    if (section == SectionActivity) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40.f)];
        UIButton *button = [[UIButton alloc]initWithFrame:view.frame];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"参加活动" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHex:@"2480FF"];
        [button addTarget:self action:@selector(onActivityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"ActivityDetailCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    // create radio button and check box
    switch (indexPath.section) {
        case SectionActivity:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"活动名称";
                cell.detailTextLabel.text = self.model.title;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"活动开始时间";
                cell.detailTextLabel.text = self.model.start_date;
                
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"活动截止时间";
                cell.detailTextLabel.text = self.model.end_date;
                
            } else if (indexPath.row == 3) {
                SSTextView *textView = [[SSTextView alloc]initWithFrame:cell.contentView.frame];
                [textView setEditable:false];
                [textView setSelectable:false];
                textView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
                [textView setEditable:false];
                [textView setSelectable:false];
                textView.font = [UIFont systemFontOfSize:13.f];
                [cell.contentView addSubview:textView];
                if (self.model.detail == nil || ![self.model.detail isEqualToString:@""])
                    textView.placeholder = @"该活动没有详细介绍";
                else
                    textView.placeholder = self.model.detail;
            }  else {}
            
            break;
        default:
            break;
    }
    return cell;
}

enum {
    AlertReasonCall = 0x400,
    AlertReasonNavi,
    AlertReasonLogin,
};

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}
#pragma mark - MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertReasonLogin && buttonIndex == 0) {
        LoginViewController *controller = [LoginViewController initWithDelegate:self tag:AlertReasonLogin];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
}
#pragma mark - LoginViewDelegate
- (void)onLoginSuccessed:(NSInteger)tag {
    [self takeActivity];
}

- (void)onActivityBtnClicked:(id) sender {
    UserModel *user = [UserModel sharedClient];
    if (![user isLogin]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户没有登录，是否登录" delegate:self cancelButtonTitle:@"登录" otherButtonTitles:@"取消", nil];
        alert.tag = AlertReasonLogin;
        [alert show:self];
        return;
    }
    [self takeActivity];
}

- (void)takeActivity {
    UserModel *user = [UserModel sharedClient];
    NSDictionary *params = @{@"role":@"user", @"user_id":user.user_id, @"activity_id":self.model.activity_id};
    
    __block SellerActivityDetailViewController *blockself = self;
    [RCar POST:rcar_api_user_activity modelClass:nil config:nil params:params success:^(NSDictionary *dataModel) {
        NSString *result = [dataModel valueForKey:@"api_result"];
        if (result.intValue == APIE_OK) {
            [blockself.navigationController popViewControllerAnimated:YES];
            
        } else {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"服务器通信错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
    } failure:^(NSString *errorStr) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"网络不能连接,请检查网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }];
    
}

@end
