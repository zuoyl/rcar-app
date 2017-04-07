//
//  MainViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 22/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerInfoModel.h"

@interface MainViewController : UITabBarController
@property (nonatomic, strong) SellerDetailInfoModel *model;

@end
