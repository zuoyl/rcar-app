//
//  OrderDetailViewController.h
//  CarUser
//
//  Created by jenson.zuo on 5/8/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderDetailModel.h"
#import "SellerModel.h"

@interface MyOrderDetailViewController : UITableViewController
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) MyOrderDetailModel *order;
- (void) loadOrderDetail;
- (void) setOrderStatus:(NSString *)status info:(NSDictionary *)info;
- (void) getOrderStatus;


@end
