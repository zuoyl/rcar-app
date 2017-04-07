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

@interface SellerInfoModel : APIResponseModel

@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSMutableArray *services;

@end


@interface SellerDetailInfoModel : APIResponseModel

@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSDictionary *location;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *service_start_time;
@property (nonatomic, strong) NSString *service_end_time;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *services;
@property (nonatomic, strong) NSMutableArray *activities;
@property (nonatomic, strong) NSMutableArray *commodities;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSArray *cars;
@property (nonatomic, strong) NSMutableArray *face_images;
@property (nonatomic, strong) NSMutableArray *eco_images;
@property (nonatomic, strong) NSMutableArray *internal_images;

@end



