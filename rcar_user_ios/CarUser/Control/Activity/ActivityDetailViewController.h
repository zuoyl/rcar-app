//
//  ActivityDetailViewController.h
//  CarUser
//
//  Created by jenson.zuo on 20/5/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerActivityModel.h"
#import "SellerInfoModel.h"

@interface ActivityDetailViewController : UITableViewController
@property (nonatomic, strong) SellerActivityModel *model;
@property (nonatomic, strong) SellerInfoModel *seller;

@end
