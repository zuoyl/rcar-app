//
//  OrderModel.h
//  CarUser
//
//  Created by jenson.zuo on 5/8/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadDB.h"

@interface OrderModel : APIResponseModel<ReadModel>

@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_type;
@property (nonatomic, strong) NSString *order_service_type;

@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *platenumber;
@property (nonatomic, strong) NSString *date_time;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray  *target_seller;
@property (nonatomic, strong) NSString *selected_seller;
@property (nonatomic, strong) NSDictionary *seller;  // sellected seller
@end


static NSString *const kOrderTypeBook = @"books";
static NSString *const kOrderTypeBidding = @"bidding";

static NSString *const kOrderStatusNew = @"new";
static NSString *const kOrderStatusConfirmed = @"confirmed";
static NSString *const kOrderStatusCompleted = @"completed";
static NSString *const kOrderStatusCanceled = @"canceled";
static NSString *const kOrderStatusUnknown = @"unknown";

static NSString *const kServiceType_CarClean = @"洗车";
static NSString *const kServiceType_CarMaintenance = @"车辆保养";
static NSString *const kServiceType_CarFault = @"故障维修";
static NSString *const kServiceType_CarSos = @"紧急救援";
static NSString *const kServiceType_Custome = @"其他";






@interface ServiceInfoList : NSObject
@property (nonatomic, strong) NSMutableArray *types;

+ (ServiceInfoList *)shared;
+ (NSString *)imageNameOfService:(NSString *)service;
@end





