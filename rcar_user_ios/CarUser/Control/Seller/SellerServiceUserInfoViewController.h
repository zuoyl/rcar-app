//
//  SellerServiceUserInfoViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 17/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "SellerServiceModel.h"

@interface SellerServiceUserInfoViewController : UIViewController <LoginViewDelegate>

@property (nonatomic, strong) ServiceContactModel *model;
@property (nonatomic, strong) IBOutlet UITextField *userNameText;
@property (nonatomic, strong) IBOutlet UITextField *telephoneText;
@property (nonatomic, strong) IBOutlet UITextField *carnoText;
@property (nonatomic, strong) IBOutlet UITextView *otherText;
@property (nonatomic, strong) IBOutlet UILabel *userHintLabel;
@property (nonatomic, strong) IBOutlet UIButton *loginBtn;

@end
