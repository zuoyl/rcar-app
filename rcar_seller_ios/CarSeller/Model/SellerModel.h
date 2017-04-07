//
//  SellerModel.h
//  CarSeller
//
//  Created by jenson.zuo on 26/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationModel.h"
#import "OrderModel.h"

@interface SellerModel : NSObject <NSCoding>
@property (nonatomic, assign) BOOL islogin;
@property (nonatomic, strong) NSString       *seller_id;
@property (nonatomic, strong) NSString       *pwd;
@property (nonatomic, strong) NSString       *telephone;
@property (nonatomic, strong) NSString       *name;
@property (nonatomic, strong) NSString       *city;
@property (nonatomic, strong) NSString       *address;
@property (nonatomic, strong) NSMutableDictionary  *location;
@property (nonatomic, strong) NSString       *detail;
@property (nonatomic, strong) NSString       *rate;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *face_images;
@property (nonatomic, strong) NSMutableArray *internal_images;
@property (nonatomic, strong) NSMutableArray *eco_images;
@property (nonatomic, strong) NSString       *service_start_time;
@property (nonatomic, strong) NSString       *service_end_time;
@property (nonatomic, strong) NSMutableArray *services;
@property (nonatomic, strong) NSMutableArray *activities;
@property (nonatomic, strong) NSMutableArray *commodities;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSMutableArray *cars;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *business;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, strong) NSMutableArray *advertisements;
@property (nonatomic, strong) NSMutableArray *accusations;
@property (nonatomic, strong) NSMutableArray *records;
@property (nonatomic, strong) NSString *lastUserId;
@property (nonatomic, strong) NSString *pushUserId;
@property (nonatomic, strong) NSString *pushChannelId;
@property (nonatomic, strong) NSMutableArray *msgs;


+ (instancetype)sharedClient;
- (void)loadDataFromNetwork:(NSString *)seller_id success:(CallSuccessBlock)success failure:(CallFailureBlock)failure;
+ (instancetype)load;
- (void)flush;
- (void)addOrder:(OrderModel *)order;
- (void)addOrders:(NSArray *)orders;
- (void)removeOrderById:(NSString *)business_id;
- (void)removeOrder:(OrderModel *)order;
- (void)updateOrderStatus:(NSString *)business_id status:(NSString *)status;
- (void)setPushId:(NSString *)userId channelId:(NSString *)channelId;
- (NSString *)getPushUserId;
- (NSString *)getPushChannelId;


@end
