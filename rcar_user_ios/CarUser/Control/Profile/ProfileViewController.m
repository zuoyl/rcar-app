//
//  ProfileViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 9/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileUserTitleCell.h"
#import "ProfileModel.h"
#import "UserInfoModel.h"
#import "CircleImageView.h"

#define CIRCLE_IMAGEVIEW_TAG (1200)

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, LoginViewDelegate>
@property (nonatomic, strong) UIBarButtonItem *rightBtnItem;
@property (nonatomic, strong) CircleImageView *userImageView;

@end

@implementation ProfileViewController {
    NSArray *_items;
}

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    UserModel *user = [UserModel sharedClient];
    
    int height = self.navigationController.navigationBar.frame.size.height - 10;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, height, height)];
    [btn addTarget:self action:@selector(userInfoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.userImageView = [[CircleImageView alloc]initWithFrame:btn.frame backgroundProgressColor:[UIColor whiteColor] progressColor:[UIColor grayColor]];
    
    
    if ([user isLogin]) {
        if ( user.info.image != nil) {
            [self.userImageView setImageURL:[[RCar imageServer] stringByAppendingString:user.info.image]];
            [btn setBackgroundImage:self.userImageView.image  forState:UIControlStateNormal];
        }
        self.navigationItem.title = user.info.user_name;
        self.rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(loginBtnClicked:)];

        
    } else {
        [self.userImageView setImageURL:@"train"];
        [btn setBackgroundImage:self.userImageView.image  forState:UIControlStateNormal];
        self.navigationItem.title = @"未登录用户";
        self.rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(loginBtnClicked:)];
    }
    [self.rightBtnItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = self.rightBtnItem;
    
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    UINib *nib = [UINib nibWithNibName:@"ProfileUserTitleCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ProfileUserTitleCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ProfileItemCell"];
    // clear noused rows
    
    [self.view bringSubviewToFront:self.tableView];
     
    _items = @[@[@"train", @"我的车辆"],
               @[@"train", @"我的收藏"],
               @[@"train", @"我的保险"],
               @[@"train", @"我的积分"],
               @[@"train", @"我的优惠劵"]];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
}

- (void)userInfoBtnClicked:(id)sender {
    
    UserModel *user = [UserModel sharedClient];
    if ([user isLogin]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"UserDetailInfoViewController"];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        self.hidesBottomBarWhenPushed = YES;
        LoginViewController *loginController = [LoginViewController initWithDelegate:self tag:0];
        [self.navigationController pushViewController:loginController animated:YES];
    }
}


- (void)loginBtnClicked:(id)sender {
    NSString *title = self.navigationItem.rightBarButtonItem.title;
    
    UserModel *user = [UserModel sharedClient];
    if ([title isEqualToString:@"登录"] && [user isLogin] == false) {
        self.hidesBottomBarWhenPushed = YES;
        LoginViewController *loginController = [LoginViewController initWithDelegate:self tag:0];
        [self.navigationController pushViewController:loginController animated:YES];
    } else {
        __block ProfileViewController *blockself = self;
        NSDictionary *params = @{@"role":@"user", @"user_id":user.user_id};
        [RCar POST:rcar_api_user_session modelClass:@"APIResponseModel" config:nil params:params success:^(APIResponseModel *model) {
            if (model.api_result == APIE_OK) {
                blockself.navigationItem.rightBarButtonItem.title = @"登录";
                blockself.navigationItem.title = @"未登录用户";
                UserModel *user = [UserModel sharedClient];
                [user setLoginStatus:NO];
                [user clearAllData];
            } else {
                [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
            }
        }failure:^(NSString *errorStr) {
            [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
        }];
    };
    
}

- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSIndexPath *indexPath  = [self.tableView indexPathForSelectedRow];
        self.hidesBottomBarWhenPushed = YES;
        LoginViewController *loginController = [LoginViewController initWithDelegate:self tag:indexPath.row];
        [self.navigationController pushViewController:loginController animated:YES];
        return;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - LonginViewDelegate
- (void)onLoginSuccessed :(NSInteger)tag{
    [self.rightBtnItem setTitle:@"注销"];
    [self loadUserProfile];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self enterProfileItem:indexPath];
    
}

- (void)loadUserProfile {
    UserModel *userModel = [UserModel sharedClient];
    NSDictionary *params = @{@"role":@"user", @"user_id":userModel.user_id};
    __block ProfileViewController *blockself = self;
    [RCar GET:rcar_api_user_profile modelClass:@"UserInfoModel" config:nil params:params success:^(UserInfoModel *model) {
        if (model.api_result == APIE_OK) {
            [UserModel sharedClient].info = model;
            [blockself refreshUserProfile];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    }failure:^(NSString *errorStr) {
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
}

- (void)refreshUserProfile {
    UserModel *user = [UserModel sharedClient];
    self.navigationItem.title = user.user_id;
    self.navigationItem.rightBarButtonItem.title = @"注销";
  //  [self.userImageView setImageURL:[RCAR_SERVER stringByAppendingString:user.info.image]];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0)return 5;
    else return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 15.f;
    else return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *itemIdentifier = @"ProfileItemCell";
    
   if (indexPath.section == 0) {
        UITableViewCell  *cell = [self.tableView dequeueReusableCellWithIdentifier:itemIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:itemIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       cell.textLabel.font = [UIFont systemFontOfSize:17.f];
        cell.textLabel.text = [_items objectAtIndex:indexPath.row][1];
        [cell.imageView setImage:[UIImage imageNamed:[_items objectAtIndex:indexPath.row][0]]];
        return cell;
   } else if (indexPath.section == 1) {
       UITableViewCell  *cell = [self.tableView dequeueReusableCellWithIdentifier:itemIdentifier];
       if (cell == nil)
           cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:itemIdentifier];
       
       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:17.f];
       cell.textLabel.text = @"通知中心";
       [cell.imageView setImage:[UIImage imageNamed:@"train"]];
       return cell;
       
       
   } else if (indexPath.section == 2) {
       UITableViewCell  *cell = [self.tableView dequeueReusableCellWithIdentifier:itemIdentifier];
       if (cell == nil)
           cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:itemIdentifier];
       
       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       cell.textLabel.font = [UIFont systemFontOfSize:17.f];
       cell.textLabel.text = @"设置";
       [cell.imageView setImage:[UIImage imageNamed:@"train"]];
       return cell;
   }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserModel *user = [UserModel sharedClient];
    if ([user isLogin] == NO) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户未登录，不能取得用户信息" delegate:self cancelButtonTitle:@"了解了" otherButtonTitles:@"登录", nil];
        [alert show:self];
        return;
    }
    [self enterProfileItem:indexPath];
}

- (void)enterProfileItem:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = nil;
    UIViewController *controller = nil;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                storyboard = [UIStoryboard storyboardWithName:@"CarInfo" bundle:nil];
                controller = [storyboard instantiateViewControllerWithIdentifier:@"CarList"];
                break;
            case 1:
                storyboard = [UIStoryboard storyboardWithName:@"Favorite" bundle:nil];
                controller = [storyboard instantiateViewControllerWithIdentifier:@"FavoriteSeller"];
                break;
            case 2:
                storyboard = [UIStoryboard storyboardWithName:@"Insurance" bundle:nil];
                controller = [storyboard instantiateViewControllerWithIdentifier:@"InsuranceViewController"];
                break;
            case 3:
                storyboard = [UIStoryboard storyboardWithName:@"Credit" bundle:nil];
                controller = [storyboard instantiateViewControllerWithIdentifier:@"CreditShopViewController"];
                break;
            case 4:
                storyboard = [UIStoryboard storyboardWithName:@"Coupon" bundle:nil];
                controller = [storyboard instantiateViewControllerWithIdentifier:@"CouponViewController"];
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        controller = [storyboard instantiateViewControllerWithIdentifier:@"NotifyCenterViewController"];
    } else if (indexPath.section == 2) {
        storyboard = [UIStoryboard storyboardWithName:@"Setup" bundle:nil];
        controller = [storyboard instantiateViewControllerWithIdentifier:@"SetupViewController"];
    }
    if (controller != nil) {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
