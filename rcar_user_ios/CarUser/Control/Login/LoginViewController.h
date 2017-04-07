//
//  LoginViewController.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-17.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate
@required
- (void)onLoginSuccessed:(NSInteger)tag;
@optional
- (void)onLoginFailed:(NSInteger)tag;
@end

@interface LoginViewController : UIViewController <MxAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, assign) id<LoginViewDelegate> delegate;
@property (nonatomic, assign) NSInteger tag;

+ (LoginViewController*) initWithDelegate:(id)sender tag:(NSInteger)tag;
@end
