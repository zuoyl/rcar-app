//
//  SellerServiceItemModel.h
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SellerInfoModel;


@interface SellerServiceModel : APIResponseModel <NSCoding>
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *service_id;
@end


@interface SellerServiceInfoList : NSObject
@property (nonatomic, strong) NSMutableArray *types;

+ (SellerServiceInfoList *)shared;
+ (NSString *)imageNameOfService:(NSString *)service;
@end

