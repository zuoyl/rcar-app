//
//  FirstViewController.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-12.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "StatusView.h"
#import "LoginViewController.h"
#import "CitySelectViewController.h"
#import "SellerSearchViewController.h"
#import "AdvertisementView.h"
#import "ServiceTableView.h"
#import "ScrollingNavbarViewController.h"


@class NILauncherViewController;

@interface HomeViewController : UIViewController<UISearchBarDelegate, CitySelectDelegate, SellerSearchDelegate>
@property (nonatomic, strong) AdvertisementView *advertiseView;
@property (nonatomic, strong) UILabel *recommendLabel;

@end

