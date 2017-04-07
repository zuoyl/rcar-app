//
//  SellerInfoModel.h
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SellerCommodityModel.h"
#import "SellerActivityModel.h"
#import "SellerCommentModel.h"
#import "APIResponseModel.h"

@interface SellerInfoModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *type; // @"4s" or @"repair"
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *services;
@property (nonatomic, strong) NSArray *activities;

@end


@interface SellerDetailInfoModel : APIResponseModel

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *services;
@property (nonatomic, strong) NSArray *activities;
@property (nonatomic, strong) NSArray *commodities;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSString *count;

- (SellerInfoModel *)sellerInfoModel;

@end

