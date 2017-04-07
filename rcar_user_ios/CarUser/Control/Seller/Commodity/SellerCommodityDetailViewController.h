//
//  CommodityDetailViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerCommodityModel.h"

@interface SellerCommodityDetailViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) SellerCommodityModel *model;

@end
