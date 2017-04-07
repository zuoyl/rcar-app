//
//  AdvertisementModel.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-14.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString * const kAdvertisementStatus_New = @"new";
static NSString * const kAdvertisementStatus_Wait = @"wait";
static NSString * const kAdvertisementStatus_Doing = @"publicated";
static NSString * const kAdvertisementStatus_Canceling = @"canceling";
static NSString * const kAdvertisementStatus_Completed = @"completed";


@interface AdvertisementModel : APIResponseModel <NSCoding>
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *ads_id;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSString *city;
@end


@interface AdvertisementRspModel : APIResponseModel
@property (nonatomic, strong) NSString *ads_id;
@property (nonatomic, strong) NSArray *images;

@end

