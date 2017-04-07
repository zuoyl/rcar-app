//
//  OrderDetailViewController.h
//  CarUser
//
//  Created by jenson.zuo on 5/8/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"

@interface OrderDetailViewController : UITableViewController
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) OrderDetailModel *order;

- (void)loadOrderDetail;
- (void) cancelBtnClicked:(id)sender;
- (void) delBtnClicked:(id)sender;


@end
