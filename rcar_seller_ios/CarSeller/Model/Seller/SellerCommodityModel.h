//
//  CommodityModel.h
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellerCommodityModel : APIResponseModel <NSCoding>

@property (nonatomic, strong) NSString *commodity_id;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSNumber *rate;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *cutoff;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *total;

@end