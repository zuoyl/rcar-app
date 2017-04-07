//
//  SellerServiceItemModel.h
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SellerInfoModel;

@interface SellerServiceModel : NSObject

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *service_id;

@end

@interface ServiceContactModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *carno;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSMutableDictionary *items;

@property (nonatomic, strong) SellerInfoModel *seller;
@property (nonatomic, strong) SellerServiceModel *service;

@end
