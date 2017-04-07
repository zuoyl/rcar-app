//
//  FavoriteViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 10/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "FavoriteCommodityViewController.h"
#import "FavoriteSellerViewController.h"
#import "LoginViewController.h"

@interface FavoriteViewController : UIViewController <MxAlertViewDelegate, LoginViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentCtrl;
@property (nonatomic, retain) FavoriteCommodityViewController *commodity;
@property (nonatomic, retain) FavoriteSellerViewController *seller;

@end
