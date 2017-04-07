//
//  CreditShopViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 10/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface CreditShopViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, LoginViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *creditLabel;

@end
