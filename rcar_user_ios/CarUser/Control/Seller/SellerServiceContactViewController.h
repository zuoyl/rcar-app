//
//  SellerServiceContactViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 9/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerServiceModel.h"
#import "ServicePublicateModel.h"

@interface SellerServiceContactViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *sellerid;
@property (nonatomic, retain) ServicePublicateModel *publicateModel;
@property (nonatomic, retain) ServiceContactModel *model;
@property (nonatomic, strong) IBOutlet UIButton *cancelBtn;
@property (nonatomic, strong) IBOutlet UIButton *laterBtn;
@property (nonatomic, strong) IBOutlet UIButton *contactBtn;
@property (nonatomic, strong) IBOutlet UIView *placeholder;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIButton *timeBtn;

@end
