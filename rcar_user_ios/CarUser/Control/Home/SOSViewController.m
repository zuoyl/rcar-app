//
//  SOSViewController.m
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-15.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import "SOSViewController.h"
#import "SOSModel.h"
#import "SellerInfoViewController.h"
#import "NotifyCenterModel.h"
#import "UserModel.h"
#import "LoginViewController.h"
#import "SSTextView.h"
#import "MVTextInputsScroller.h"
@interface SOSViewController () <LoginViewDelegate, UITextViewDelegate>
@property (nonatomic, strong) MVTextInputsScroller *inputsScroller;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SOSViewController {
    UserModel * _user;
    CLLocationManager *_locationMgr;
    UIActivityIndicatorView *_activity;
    CLLocation *_location;
    SOSModel *_sos;
    NSMutableDictionary *_sellers;
    BOOL _isPublicated;
    SSTextView *_contentTextView;
}

@synthesize mapView;
@synthesize publicateBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"紧急救援";
    self.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    _user = [UserModel sharedClient];
    if (![_user isLogin]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(loginBtnClicked:)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(historyBtnClicked:)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    }
    
    // display activity indicator
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    _activity.backgroundColor = [UIColor grayColor];
    _activity.alpha = 0.5;
    _activity.layer.cornerRadius = 6;
    _activity.layer.masksToBounds = YES;
    [self.view addSubview:_activity];
    
    
    // get location
    if ([CLLocationManager locationServicesEnabled]) {
        _locationMgr = [[CLLocationManager alloc] init];
        [_locationMgr setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationMgr.delegate = self;
        _locationMgr.distanceFilter = 1000.0f;
        [_locationMgr startUpdatingLocation];
     
    } else {
        MxAlertView *alert = [[MxAlertView alloc] initWithTitle:@"信息提示" message:@"不能访问GPS" delegate:nil cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
        [alert show:self];
    }
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.scrollView];
    
    // create map view
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 190.f)];
    self.mapView.delegate = self;
    [self.scrollView addSubview:self.mapView];
    
    // create information header
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 190.f, self.view.frame.size.width, 30.f)];
    titleView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    [self.scrollView addSubview:titleView];
    
    UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 5, 30.f)];
    tagLabel.backgroundColor = [UIColor colorWithHex:@"2480ff"];
    [titleView addSubview:tagLabel];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 20, 30.f)];
    textLabel.text = @"紧急救援情况描述";
    textLabel.font = [UIFont systemFontOfSize:15.f];
    textLabel.contentMode = UIControlContentVerticalAlignmentCenter;
    [titleView addSubview:textLabel];
    [self.scrollView addSubview:titleView];
    
    _contentTextView = [[SSTextView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 160.f, self.view.frame.size.width, 120.f)];
    _contentTextView.font = [UIFont systemFontOfSize:15.f];
    _contentTextView.delegate = self;
    _contentTextView.placeholder = @"请输入您所需要的紧急救援服务,或者要求，便于商家联系您";
    _contentTextView.keyboardType = UIKeyboardTypeAlphabet;
    _contentTextView.returnKeyType = UIReturnKeyDone;
    [self.scrollView addSubview:_contentTextView];
    
    // create publicate button
    self.publicateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    [self.publicateBtn setTitle:@"发布紧急救援" forState:UIControlStateNormal];
    [self.publicateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.publicateBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    self.publicateBtn.backgroundColor = [UIColor colorWithHex:@"2480ff"];
    [self.publicateBtn addTarget:self action:@selector(publicateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.publicateBtn setEnabled:_user.isLogin];
    [self.scrollView addSubview:self.publicateBtn];
    
    _isPublicated = false;
    
    // scroll view support
    // Register inputs scroller
    self.inputsScroller = [[MVTextInputsScroller alloc] initWithScrollView:self.scrollView];
    // Dismiss keyboard on drag
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // Dismiss keyboard on tap
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
    
    if (!_user.isLogin) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户未登录,不能使用紧急救援" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:@"登录", nil];
        [alert show:self];
        return;
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    self.mapView.delegate = nil;
    self.mapView = nil;
    if (_sos.status == SOS_Status_Waiting) {
        _sos.status = SOS_Status_Waiting_NoDisplay;
    }
}
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView.returnKeyType == UIReturnKeyDone) {
        [self.view endEditing:YES];
    }
    
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}


#pragma mark - LocationManager
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _location = [locations objectAtIndex:0];
    [_locationMgr stopUpdatingLocation];
}

- (void)publicateBtnClicked:(id)sender {
    if (!_isPublicated)
        [self publicateSOS];
    else
        [self setSOSStatus:@"cancel"];

}

- (void)setSOSStatus:(NSString*)status {
    if (_sos.sos_id == nil) return;
    NSDictionary *params = @{@"role":@"user", @"user_id":_user.user_id, @"sos_id":_sos.sos_id, @"status":status};
    
    [_activity startAnimating];
    [RCar PUT:rcar_api_user_sos modelClass:nil config:nil params:params success:^(NSDictionary * data) {
        [_activity stopAnimating];
        NSString *result = [data objectForKey:@"api_result"];
        if (result.intValue == APIE_OK) {
            _sos.sos_id = nil;
            _sos.status = SOS_Status_Waiting;
            _isPublicated = false;
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    } failure:^(NSString *errorStr) {
        [_activity stopAnimating];
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
}
- (void)publicateSOS {
    // check wethere sos had been publicated
    if (_isPublicated)
        return [self setSOSStatus:@"cancel"];
    
    // check parameter
    if ([_contentTextView.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"请填写您所需要的紧急救援项目" delegate:nil cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"role":@"user"}];
    if (_location) {
        double lat = _location.coordinate.latitude;
        double lon = _location.coordinate.longitude;
        [params setValue:@{@"lat":[NSNumber numberWithDouble:lat] , @"lon":[NSNumber numberWithDouble:lon]} forKey:@"location"];
    }
    
    // if the user is logined, just user telephone
    [params setObject:_user.user_id forKey:@"user_id"];
    [params setObject:_contentTextView.text forKey:@"content"];
    
    __block SOSViewController *blockself = self;
    [_activity startAnimating];
    [RCar POST:rcar_api_user_sos modelClass:nil config:nil params:params success:^(NSDictionary * data) {
        [_activity stopAnimating];
        
        NSString *result = [data objectForKey:@"api_result"];
        if (result.intValue == APIE_OK) {
            _sos.sos_id = [data objectForKey:@"sos_id"];
            _sos.status = SOS_Status_Waiting;
            _isPublicated = true;
            [blockself.publicateBtn setTitle:@"取消紧急救援" forState:UIControlStateNormal];
        } else {
            [CommonUtil showHintHUD:Data_Load_Failure inView:self.view originY:Hint_Show_PositionY];
        }
    } failure:^(NSString *errorStr) {
        [_activity stopAnimating];
        [CommonUtil showHintHUD:errorStr inView:self.view originY:Hint_Show_PositionY];
    }];
    
}

- (void)displaySellerOnMap:(NSString *)sellerId location:(NSDictionary *)location {
    
}
             
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    segue.destinationViewController.hidesBottomBarWhenPushed = YES;
}

#pragma mark - MxAlertViewDelegate
- (void)alertView:(MxAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex == 1) {
        LoginViewController *loginController = [LoginViewController initWithDelegate:self tag:0];
        loginController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginController animated:YES];
        return;
    }
    
}

#pragma mark - StatusViewDelegate
- (void)loginBtnClicked:(id)sender {
    if (!_user.isLogin) { // login
        LoginViewController *loginController = [LoginViewController initWithDelegate:self tag:0];
        loginController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginController animated:YES];
    }
}

#pragma mark - LonginViewDelegate
- (void)onLoginSuccessed :(NSInteger)tag {
    [self.publicateBtn setEnabled:_user.isLogin];
    [self updateToobarItems];
   
}

- (void)historyBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"segue_sos_history" sender:self];

}

- (void)cancelBtnClicked:(id)sender {
    [self setSOSStatus:@"cancel"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)completeBtnClicked:(id)sender {
    [self setSOSStatus:@"complete"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateToobarItems {
    NSMutableArray *items = [[NSMutableArray alloc]init];
    
    if (_isPublicated) {
        UIBarButtonItem *completeItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeBtnClicked:)];
        [completeItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
        
        [items addObject:completeItem];
    }
    
    UIBarButtonItem *historyItem = [[UIBarButtonItem alloc]initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(historyBtnClicked:)];
    [historyItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    [items addObject:historyItem];
    self.navigationItem.rightBarButtonItems = items;
}



@end
