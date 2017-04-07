//
//  ServiceReserveViewController.h
//  CarUser
//
//  Created by huozj on 2/2/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerInfoModel.h"

@interface ServiceReserveViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *serviceList;
@property (nonatomic, strong) SellerInfoModel *seller;


@end
