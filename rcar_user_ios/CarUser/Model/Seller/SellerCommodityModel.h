//
//  CommodityModel.h
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIResponseModel.h"

@interface SellerCommodityModel : APIResponseModel<NSCoding>

@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *band;
@property (nonatomic, strong) NSString *cutoff;
@property (nonatomic, strong) NSNumber *left;
@property (nonatomic, strong) NSMutableArray *comments;

@end