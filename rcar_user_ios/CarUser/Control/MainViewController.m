//
//  MainViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 17/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "MainViewController.h"
#import "NotifyCenterModel.h"
#import "LoginViewController.h"

@interface MainViewController ()<CLLocationManagerDelegate, UITabBarControllerDelegate, MxAlertViewDelegate, LoginViewDelegate>

@end

@implementation MainViewController {
    SOSModel *_sos;
    CLLocationManager *_locationMgr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    //self.tabBar.delegate = self;
    [self initLocationManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    //[_sos removeObserver:self forKeyPath:@"date"];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)initLocationManager {
    // get location
    if ([CLLocationManager locationServicesEnabled]) {
        _locationMgr = [[CLLocationManager alloc] init];
        [_locationMgr setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationMgr.delegate = self;
        _locationMgr.distanceFilter = 1000.0f;
        [_locationMgr startUpdatingLocation];
        //[self.activity startAnimating];
    } else {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:@"警告" message:@"位置服务不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设定", nil];
        [alert show:self];
    }
    
#if 1 // for simulation test
    CLLocation *location = [[CLLocation alloc]initWithLatitude:38.85464 longitude:121.524257];
    [self locationManager:_locationMgr didUpdateLocations:[NSArray arrayWithObject:location]];
#endif
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //[self.activity stopAnimating];
    CLLocation *location = [locations lastObject];
    //NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude] ;
    //NSNumber *lng = [NSNumber numberWithDouble:location.coordinate.longitude] ;
    //[_locationMgr stopUpdatingLocation];
    UserModel *userModel = [UserModel sharedClient];
    userModel.location = location;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    MxAlertView *alert = [[MxAlertView alloc] initWithTitle:@"警告" message:@"位置服务不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设定", nil];
    [alert show:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
#if 0
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    UserModel *user = [UserModel sharedClient];
    
    if (index == 1) {
        if (!user.isLogin) {
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户未登录，不能取得用户信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"登录", nil];
          //  alert.tag = AlertReason_Login;
            [alert show:self];
            return false;
        }
    }
#endif
    return true;
}
- (void)onLoginSuccessed:(NSInteger)tag {
    // select the second item
    UIViewController *controller = self.viewControllers[1];
    controller.hidesBottomBarWhenPushed = NO;
    [self setSelectedViewController:controller];
    
}

- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        LoginViewController *loginController = [LoginViewController initWithDelegate:self tag:0];
        loginController.hidesBottomBarWhenPushed = YES;
        UINavigationController *naviController =  self.viewControllers[0];
        [naviController.topViewController.navigationController
         pushViewController:loginController animated:YES];
    }
    
}





@end
