//
//  ActivityModel.h
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kActivityStatus_Doing = @"publicated";
static NSString * const kActivityStatus_Completed = @"completed";
static NSString * const kActivityStatus_Unknown = @"unknown";


@interface SellerActivityModel : APIResponseModel <NSCoding>

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *activity_id;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *start_date;
@property (nonatomic, strong) NSString *end_date;
@property (nonatomic, strong) NSMutableArray *images;

@end
