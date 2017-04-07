//
//  SellerActivityViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 30/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerActivityModel.h"

@interface SellerActivityDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, assign) SellerActivityModel *model;

@end
