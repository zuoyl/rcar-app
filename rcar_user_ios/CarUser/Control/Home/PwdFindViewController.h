//
//  PwdFindViewController.h
//  CarUser
//
//  Created by huozj on 1/6/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PwdFindViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *mobileText;
@property (nonatomic, strong) IBOutlet UITextField *pwdText;
@property (nonatomic, strong) IBOutlet UITextField *confirmPwdText;
@property (nonatomic, strong) IBOutlet UITextField *codeText;
@property (nonatomic, strong) IBOutlet UIButton *resetBtn;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;

@end