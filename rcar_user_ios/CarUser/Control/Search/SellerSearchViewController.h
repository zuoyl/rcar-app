//
//  SellerSearchViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 25/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXPullDownMenu.h"

@protocol SellerSearchDelegate
@required
- (void)sellerSearchComplete:(NSDictionary *)result;
@end


@interface SellerSearchViewController : UIViewController <UISearchBarDelegate,MXPullDownMenuDelegate>
@property (nonatomic, strong, retain) id<SellerSearchDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

- (void)searchComplete:(NSDictionary *)result;

@end
