//
//  SellerServiceListViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 30/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerServiceModel.h"
#import "SellerInfoModel.h"

@interface SellerServiceDetailViewController : UITableViewController

@property (nonatomic, strong) SellerServiceModel *serviceModel;
@property (nonatomic, strong) SellerInfoModel *sellerModel;
@property (nonatomic, assign) BOOL isDisplaySellerInfo;



@end
