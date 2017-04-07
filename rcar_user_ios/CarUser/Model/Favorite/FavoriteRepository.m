//
//  FavoriteRepository.m
//  CarSeller
//
//  Created by jenson.zuo on 15/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "FavoriteRepository.h"
#import "FavoriteModel.h"
#import "DCArrayMapping.h"

#import "SellerInfoModel.h"
#import "SellerServiceModel.h"
#import "SellerCommentModel.h"
#import "SellerActivityModel.h"
#import "SellerCommodityModel.h"

#define FAVORITE_MAX_ITEMS 20
#define FAVORITE_PATH_SELLER @"sellerFavoriteArchive"
#define FAVORITE_PATH_COMMODITY @"commodityFavoriteArchive"


@interface FavoriteRepository ()
@property (nonatomic, strong) NSString *sellerArchiveFilePath;
@property (nonatomic, strong) NSString *commodityArchiveFilePath;
@end

@implementation FavoriteRepository

+ (FavoriteRepository *)sharedClient {
    static FavoriteRepository *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[FavoriteRepository alloc] init];
        
    });
    return _sharedClient;
}
- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.sellers = [[NSMutableArray alloc]init];
        self.commodities = [[NSMutableArray alloc]init];
        self.isLoaded = false;
        self.max = FAVORITE_MAX_ITEMS;
        self.modified = false;
        self.isLoaded = false;
    }
    return self;
}

- (void)reload {
    self.isLoaded = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSMutableArray *entries = [NSKeyedUnarchiver unarchiveObjectWithFile:[documentsDirectory stringByAppendingString:FAVORITE_PATH_SELLER]];
    if (entries != nil)
        [self.sellers addObjectsFromArray:entries];
    
    entries = [NSKeyedUnarchiver unarchiveObjectWithFile:[documentsDirectory stringByAppendingString:FAVORITE_PATH_COMMODITY]];
    if (entries != nil)
        [self.commodities addObjectsFromArray:entries];
    
    self.max = FAVORITE_MAX_ITEMS;
    if (self.sellers.count > 0 || self.commodities.count > 0)
        self.isLoaded = YES;
}

- (BOOL)flush {
    BOOL result = false;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if (self.sellers.count > 0)
        result = [NSKeyedArchiver archiveRootObject:self.sellers toFile:[documentsDirectory stringByAppendingString:FAVORITE_PATH_SELLER]];
    if (self.commodities.count > 0)
        result |= [NSKeyedArchiver archiveRootObject:self.commodities toFile:[documentsDirectory stringByAppendingString:FAVORITE_PATH_COMMODITY]];
    return result;
}


- (void) addItem:(id)item type:(NSString *)type {
    
    self.modified = true;
    if ([type isEqualToString:FavoriteType_Seller]) {
        if (self.sellers.count > self.max) {
            // delete old recent items
            [self.sellers removeObjectAtIndex:0];
        }
        [self.sellers addObject:item];
    } else  if ([type isEqualToString:FavoriteType_Commodity]){
        if (self.commodities.count > self.max) {
            // delete old recent items
            [self.commodities removeObjectAtIndex:0];
        }
        [self.commodities addObject:item];
    } else {
        // do nothing
    }
}

- (void) removeItem:(NSInteger)index type:(NSString *)type {
    self.modified = true;
    
    if ([type isEqualToString:FavoriteType_Seller]) {
        [self.sellers removeObjectAtIndex:index];
    } else  if ([type isEqualToString:FavoriteType_Commodity]){
        [self.commodities removeObjectAtIndex:index];
    } else {
        // do nothing
    }
}

- (void) removeDetailItem:(id)item type:(NSString *)type {
    self.modified = true;
    
    if ([type isEqualToString:FavoriteType_Seller]) {
        SellerInfoModel *seller = item;
        for (SellerInfoModel *obj in self.sellers) {
            if ([seller.seller_id isEqualToString:obj.seller_id]) {
                [self.sellers removeObject:seller];
                break;
            }
        }
    } else  if ([type isEqualToString:FavoriteType_Commodity]){
        SellerCommodityModel *commodity = item;
        for (SellerCommodityModel *obj in self.sellers) {
            if ([commodity.seller_id isEqualToString:obj.seller_id]) {
                [self.sellers removeObject:commodity];
                break;
            }
        }
    } else {
        // do nothing
    }
  
}

- (NSInteger) count:(NSString *)type {
    if ([type isEqualToString:FavoriteType_Seller])
        return self.sellers.count;
    else if ([type isEqualToString:FavoriteType_Commodity])
        return _commodities.count;
    else
        return 0;
}

- (id)itemAtIndex:(NSInteger)index type:(NSString *)type {
    if ([type isEqualToString:FavoriteType_Seller])
        return [self.sellers objectAtIndex:index];
    else if ([type isEqualToString:FavoriteType_Commodity])
        return [self.commodities objectAtIndex:index];
    else
        return nil;
}

- (BOOL)isObjectExist:(NSString *)name type:(NSString *)type {
    if ([type isEqualToString:FavoriteType_Seller]) {
        for (int index = 0; index < self.sellers.count; index++) {
            SellerDetailInfoModel *model = [self.sellers objectAtIndex:index];
            if ([model.seller_id isEqualToString:name])
                return true;
        }
    }
    else if ([type isEqualToString:FavoriteType_Commodity]) {
        for (int index = 0; index < self.commodities.count; index++) {
            SellerCommodityModel *model = [self.commodities objectAtIndex:index];
            if ([model.cid isEqualToString:name])
                return true;
        }
    }
    return false;
}


- (void)setMaxItems:(NSInteger)val {
    self.max = val;
}

- (void)sychonizeFavorite:(CallSuccessBlock)success failure:(CallFailureBlock)failure {
    if (self.sellers.count > 0 || self.commodities.count > 0) {
        NSMutableArray *sellers = [[NSMutableArray alloc]init];
        for (int index = 0; index < self.sellers.count; index++) {
            SellerInfoModel *sellerModel = [self.sellers objectAtIndex:index];
            [sellers addObject:sellerModel.seller_id];
        }
        NSMutableArray *commodities = [[NSMutableArray alloc]init];
        for (int index = 0; index < self.commodities.count; index++) {
            SellerCommodityModel *commodityModel = [self.commodities objectAtIndex:index];
            [commodities addObject:commodityModel.cid];
        }
        UserModel *user = [UserModel sharedClient];
        
        NSDictionary *params = @{@"role":@"user", @"user_id": user.user_id, @"sellers":sellers, @"commodities":commodities};
        //DCParserConfiguration *config = [DCParserConfiguration configuration];
        [RCar POST:rcar_api_user_favorite modelClass:nil config:nil params:params success:^(NSDictionary *data) {
            success(nil);
        } failure:^(NSString *errorStr) {
            NSLog(@"failt to get seller`s detail info");
            failure(errorStr);
        }];
    }
    
}
- (void)loadFavoriteFromNetwork:(CallSuccessBlock)success failure:(CallFailureBlock)failure {
    
    [self.sellers removeAllObjects];
    [self.commodities removeAllObjects];
    
    UserModel *usrModel = [UserModel sharedClient];
    NSDictionary *params = @{@"role":@"user", @"user_id":usrModel.user_id};
    
    DCArrayMapping *smapper = [DCArrayMapping mapperForClassElements:[SellerInfoModel class] forAttribute:@"sellers" onClass:[FavoriteModel class]];
    DCArrayMapping *cmapper = [DCArrayMapping mapperForClassElements:[SellerCommodityModel class] forAttribute:@"commodities" onClass:[FavoriteModel class]];
    
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    
    [config addArrayMapper:smapper];
    [config addArrayMapper:cmapper];
    
    __block FavoriteRepository *blockself = self;
    [RCar GET:rcar_api_user_favorite modelClass:@"FavoriteModel" config:config params:params success:^(FavoriteModel *model) {
        if (model.api_result == APIE_OK) {
            blockself.isLoaded = true;
            [blockself.sellers removeAllObjects];
            [blockself.commodities removeAllObjects];
            [blockself.sellers addObjectsFromArray:model.sellers];
            [blockself.commodities addObjectsFromArray:model.commodities];
            if (success) success(blockself);
        } else {
            if (failure) failure(Data_Load_Failure);
        }
    }failure:^(NSString *errorStr) {
        if (failure) failure(errorStr);
    }];
    
}

@end
