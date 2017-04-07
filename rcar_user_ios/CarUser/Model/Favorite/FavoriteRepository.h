//
//  FavoriteRepository.h
//  CarSeller
//
//  Created by jenson.zuo on 15/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SellerInfoModel.h"
#import "SellerCommodityModel.h"

#define FavoriteType_Seller     @"seller"
#define FavoriteType_Commodity  @"commodity"

@interface FavoriteRepository : NSObject
@property (nonatomic, strong) NSMutableArray *sellers;
@property (nonatomic, strong) NSMutableArray *commodities;
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, assign) BOOL modified;


+ (FavoriteRepository *)sharedClient;
- (void) reload;
- (void) addItem:(id)model type:(NSString *)type;
- (void) removeItem:(NSInteger)index type:(NSString *)type;
- (void) removeDetailItem:(id)item type:(NSString *)type;
- (NSInteger) count:(NSString *)type ;
- (id )itemAtIndex:(NSInteger)index type:(NSString *)type;
- (BOOL)flush;
- (BOOL)isObjectExist:(NSString *)name type:(NSString *)type;
- (void)loadFavoriteFromNetwork:(CallSuccessBlock)success failure:(CallFailureBlock)failure;
- (void)sychonizeFavorite:(CallSuccessBlock)success failure:(CallFailureBlock)failure;


@end
