//
//  OrderModel.h
//  CarSeller
//
//  Created by jenson.zuo on 25/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIResponseModel.h"
#import "ReadDB.h"



@interface OrderModel : APIResponseModel<ReadModel>
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_type;
@property (nonatomic, strong) NSString *order_service_type;

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *platenumber;
@property (nonatomic, strong) NSString *date_time;
@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *mode;
@property (nonatomic, strong) NSArray  *target_seller;
@property (nonatomic, strong) NSDictionary *detail;

@end


#define kOrderTypeBook  @"books"
#define kOrderTypeBidding @"bidding"
#define kServiceType_CarClean  @"洗车"
#define kServiceType_CarMaintenance @"车辆保养"
#define kServiceType_CarFault  @"故障维修"
#define kServiceType_CarSos  @"紧急救援"
#define kServiceType_Custome  @"其他"