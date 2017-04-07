//
//  NewVersionViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 29/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "NewVersionViewController.h"
#import "iVersion.h"

@interface NewVersionViewController () <iVersionDelegate, MxAlertViewDelegate>
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation NewVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"新版本检测";
    
    // display activity indicator
    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    self.activity.backgroundColor = [UIColor lightGrayColor];
    self.activity.alpha = 0.5;
    self.activity.layer.cornerRadius = 6;
    self.activity.layer.masksToBounds = YES;
    [self.view addSubview:self.activity];
    [iVersion sharedInstance].applicationBundleID = @"rcar.seller.application.bundle.id";
    
    iVersion *version = [iVersion sharedInstance];
    version.delegate = self;
    if (![version shouldCheckForNewVersion]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"软件版本检测选项没有打开,不能检测" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    [version checkIfNewVersion];
    // display activity
    [self.activity startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - iVersionDelegate
- (BOOL)iVersionShouldCheckForNewVersion {
    return true;
}
- (void)iVersionDidNotDetectNewVersion {
    [self.activity stopAnimating];
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"没有检测到新的版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show:self];
    return;

}
- (void)iVersionVersionCheckDidFailWithError:(NSError *)error {
     [self.activity stopAnimating];
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"软件检测失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show:self];
    return;
    
    
}
- (void)iVersionDidDetectNewVersion:(NSString *)version details:(NSString *)versionDetails {
     [self.activity stopAnimating];
    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"检测到新版本" message:version delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"去App商店", nil];
    [alert show:self];
    return;
}

- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
        [self.navigationController popViewControllerAnimated:YES];
    else {
        iVersion *version = [iVersion sharedInstance];
        [version openAppPageInAppStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
