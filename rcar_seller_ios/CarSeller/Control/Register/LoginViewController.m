//
//  ViewController.m
//  CarSeller
//
//  Created by jenson.zuo on 22/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "LoginViewController.h"
#import "SellerInfoModel.h"
#import "SellerServiceModel.h"
#import "SellerModel.h"
#import "RegisterModel.h"
#import "MYBlurIntroductionView.h"
#import "MYIntroductionPanel.h"

#define MAX_RETRY_COUNT 3

@interface LoginViewController ()<UINavigationControllerDelegate, MYIntroductionDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *backImageView;
@end

@implementation LoginViewController {
    SellerModel *_seller;
    int _retryCount;
}

@synthesize nameLabel;
@synthesize pwdLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"车老板商家端";
    _seller = [SellerModel sharedClient];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
    self.navigationController.delegate = self;
    
    self.backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_back"]];
    [self.backImageView setFrame:self.view.frame];
    [self.view addSubview:self.backImageView];
    
    self.nameLabel.text = _seller.seller_id;
    self.pwdLabel.delegate = self;
    
    for (UIView *view in self.view.subviews) {
        if (view != self.backImageView)
            [self.view bringSubviewToFront:view];
    }
 //   [self.view bringSubviewToFront:self.nameLabel];
 //   [self.view bringSubviewToFront:self.pwdLabel];
    
    [self buildIntro];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Build MYBlurIntroductionView



-(void)buildIntro{
    //Create Stock Panel with header
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:nil description:nil image:[UIImage imageNamed:@"Launch1.jpg"]];
    
    
    //Create Stock Panel With Image
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:nil description:nil image:[UIImage imageNamed:@"Launch2.png"]];
    
    
    //Add panels to an array
    NSArray *panels = @[panel1, panel2];
    
    //Create the introduction view and set its delegate
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    introductionView.delegate = self;
    introductionView.BackgroundImageView.image = [UIImage imageNamed:@"Launch1.jpg"];
    [introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:1]];
    
    //Build the introduction with desired panels
    [introductionView buildIntroductionWithPanels:panels];
    
    //Add the introduction to your view
    [self.view addSubview:introductionView];
}

#pragma mark - UINavigationController Delegate Methods
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ( viewController == self ) {
        [navigationController setNavigationBarHidden:YES animated:animated];
    } else if ( [navigationController isNavigationBarHidden] ) {
        [navigationController setNavigationBarHidden:NO animated:animated];
    }
}

#pragma mark - MYIntroduction Delegate

-(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    
    //You can edit introduction view properties right from the delegate method!
    //If it is the first panel, change the color to green!
    if (panelIndex == 0) {
        [introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:1]];
    }
    //If it is the second panel, change the color to blue!
    else if (panelIndex == 1){
        [introductionView setBackgroundColor:[UIColor colorWithRed:50.0f/255.0f green:79.0f/255.0f blue:133.0f/255.0f alpha:1]];
    }
    
}

-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
    NSLog(@"Introduction did finish");
}




- (IBAction)loginBtnTaped:(id)sender {
    if ([nameLabel.text isEqualToString:@""] || [pwdLabel.text isEqualToString:@""]) {
        MxAlertView *alert = [[MxAlertView alloc]initWithTitle:nil message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
        [alert show:self];
        return;
    }
   // [_activity startAnimating];
#if 1
    [self loginSeller];
#else 
    [self performSegueWithIdentifier:@"show_main" sender:self];
#endif

}

- (void)loginSeller {
#if 0
    if (![RCar isConnected]) {
        [self setCurrentState:ViewStatusNoNetwork];
        return;
    }
#endif 
    
   [self setCurrentState:ViewStatusCalling];
    
    __block LoginViewController *blockself = self;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{@"role":@"seller", @"id":self.nameLabel.text, @"pwd":self.pwdLabel.text, @"device_type":@"ios"}];
    
    SellerModel *seller = [SellerModel sharedClient];
    if (seller.pushUserId != nil && seller.pushChannelId != nil) {
        [params setValue:seller.pushUserId forKey:@"push_user_id"];
        [params setValue:seller.pushChannelId forKey:@"push_channel_id"];
    }
    
    
    [RCar POST:rcar_api_seller_session modelClass:@"APIResponseModel" config:nil  params:params success:^(APIResponseModel *model) {
        if (model.api_result == APIE_OK) {
            
#if 0
            // if there is no seller logined before
            if (!_seller.seller_id ||[_seller.seller_id isEqualToString:@""]) {
                _seller.seller_id = blockself.nameLabel.text;
                _seller.islogin = true;
                [_seller loadDataFromNetwork:_seller.seller_id success:^(id result) {
                    [blockself setCurrentState:ViewStatusCallFinished];
                    [blockself performSegueWithIdentifier:@"show_main" sender:blockself];
                    
                } failure:^(NSString *errorStr) {
                    [blockself setCurrentState:ViewStatusCallFinished];
                    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"登录失败" message:@"不能加载商家详细情报" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
                    [alert show:self];
                    return;
                    
                }];
            
            } else if (![_seller.seller_id isEqualToString:blockself.nameLabel.text]) {
                // if the login is used by another user
                [_seller flush];
                _seller.seller_id = blockself.nameLabel.text;
                _seller.islogin = true;

                [_seller loadDataFromNetwork:_seller.seller_id success:^(id result) {
                    [blockself setCurrentState:ViewStatusCallFinished];
                    [blockself performSegueWithIdentifier:@"show_main" sender:blockself];
                } failure:^(NSString *errorStr) {
                    [blockself setCurrentState:ViewStatusCallFinished];
                    MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"登录失败" message:@"不能加载商家详细情报" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
                    [alert show:self];
                    return;
                }];
                
            } else {
                [blockself setCurrentState:ViewStatusCallFinished];
                // do nothing, just jump
                _seller.islogin = true;
                _seller.lastUserId = blockself.nameLabel.text;
                [blockself performSegueWithIdentifier:@"show_main" sender:blockself];
            }
#else 
            _seller.islogin = true;
            _seller.seller_id = blockself.nameLabel.text;
            
            [_seller loadDataFromNetwork:_seller.seller_id success:^(id result) {
                [blockself setCurrentState:ViewStatusCallFinished];
                [blockself performSegueWithIdentifier:@"show_main" sender:blockself];
                
            } failure:^(NSString *errorStr) {
                [blockself setCurrentState:ViewStatusCallFinished];
                MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"登录失败" message:@"不能加载商家详细情报" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
                [alert show:self];
                return;
                
            }];
#endif
        } else {
            [blockself setCurrentState:ViewStatusCallFailed];
            //[_activity stopAnimating];
            MxAlertView *alert = [[MxAlertView alloc]initWithTitle:@"登录失败" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"了解了" otherButtonTitles:nil, nil];
            [alert show:self];
            return;
        }
    } failure:^(NSString *errorStr) {
        [blockself setCurrentState:ViewStatusNoNetwork];
        return;
    }];
    
}

- (IBAction)registerBtnTaped:(id)sender {
    RegisterModel *model = [RegisterModel sharedClient];
    if (model.step == RegisterModelStep1)
        [self performSegueWithIdentifier:@"show_register" sender:self];
    else if (model.step == RegisterModelStep2) {
        [self performSegueWithIdentifier:@"register_detail" sender:self];
    }
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![self.nameLabel.text isEqualToString:@""]) {
        [self loginBtnTaped:self];
        return YES;
    } else {
        return NO;
    }
}




@end
