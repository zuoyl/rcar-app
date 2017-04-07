//
//  RecordListViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 2/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyViewController.h"

@interface RecordListViewController : MyViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@end
