//
//  MyViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 8/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) StatusView *statusView;

@end

@implementation MyViewController

- (void)viewDidLoad {
    self.mode = ReachabilityModeOverlay;
    self.visibilityTime = 3.0;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.statusView = [[StatusView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.statusView];
    [self.statusView setStatus:ViewStatusNormal];
    
    // display activity indicator
    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    self.activity.backgroundColor = [UIColor whiteColor];
    self.activity.alpha = 0.5;
    self.activity.layer.cornerRadius = 6;
    self.activity.layer.masksToBounds = YES;
    [self.view addSubview:self.activity];
    
    

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) setCurrentState:(ViewStatusType)status {
    switch (status) {
        case ViewStatusCalling:
            [self.activity startAnimating];
            break;
        case ViewStatusCallFinished:
            [self.activity stopAnimating];
            break;
        case ViewStatusCallFailed: {
            [self.activity stopAnimating];
            break;
        }
        case ViewStatusNoNetwork:{
            [self.activity stopAnimating];
            break;
        }
        default:
            //[_statusView setStatus:status];
        break;
    }
}

@end
