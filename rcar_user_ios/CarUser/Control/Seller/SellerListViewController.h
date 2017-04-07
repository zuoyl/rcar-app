//
//  SellerListViewController.h
//  CarUser
//
//  Created by jenson.zuo on 17/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerInfoCell.h"
#import "SellerSelectDelegate.h"
#import "LoginViewController.h"
#import "OverlapView.h"


@protocol SellerListSelectDelegate <NSObject>

@optional
- (void)sellerListSelected:(NSMutableArray *)sellerList;

@end


@interface SellerListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MxAlertViewDelegate, SellerSelectDelegate, UISearchBarDelegate, OverlapViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) id<SellerListSelectDelegate> delegate;

@end
