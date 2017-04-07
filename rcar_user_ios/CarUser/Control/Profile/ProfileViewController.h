//
//  ProfileViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 9/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "ScrollingNavbarViewController.h"

@interface ProfileViewController : ScrollingNavbarViewController <LoginViewDelegate, MxAlertViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
