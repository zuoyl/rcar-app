//
//  FaultWaitingViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 25/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKMapView.h"

@interface OrderWaitingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_type;
@property (nonatomic, weak) UIViewController *rootController;

@end
