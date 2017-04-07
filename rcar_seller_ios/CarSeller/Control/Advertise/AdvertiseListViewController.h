//
//  AdvertiseListViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 1/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertiseListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
