//
//  ActivityViewController.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-15.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)  UITableView *tableView;

@end
