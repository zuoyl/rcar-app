//
//  ServiceCarCleanListViewController.h
//  CarUser
//
//  Created by huozj on 1/27/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ServiceListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MxAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL isChildController;
@end
