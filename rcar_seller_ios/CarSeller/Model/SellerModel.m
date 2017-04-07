//
//  SellerModel.m
//  CarSeller
//
//  Created by jenson.zuo on 26/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "SellerModel.h"
#import "SellerInfoModel.h"
#import "SellerServiceModel.h"
#import "SellerActivityModel.h"
#import "SellerCommodityModel.h"
#import "SellerCommentModel.h"
#import "RCar.h"
#import "UserGroupModel.h"

@implementation SellerModel
+ (instancetype)sharedClient {
    static SellerModel *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_sharedClient == nil)
            _sharedClient = [SellerModel load];
        if (_sharedClient == nil)
            _sharedClient = [[SellerModel alloc]init];
        
    });
    return _sharedClient;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.services = [[NSMutableArray alloc]init];
        self.images = [[NSMutableArray alloc]init];
        self.face_images = [[NSMutableArray alloc]init];
        self.internal_images = [[NSMutableArray alloc]init];
        self.eco_images = [[NSMutableArray alloc]init];
        
        self.commodities = [[NSMutableArray alloc]init];
        self.comments = [[NSMutableArray alloc]init];
        self.activities = [[NSMutableArray alloc]init];
        self.users = [[NSMutableArray alloc]init];
        self.business = [[NSMutableArray alloc]init];
        self.orders = [[NSMutableArray alloc]init];
        self.activities = [[NSMutableArray alloc]init];
        self.records = [[NSMutableArray alloc]init];
        self.advertisements = [[NSMutableArray alloc]init];
        self.accusations = [[NSMutableArray alloc]init];
        self.groups = [[NSMutableArray alloc]init];
        self.users = [[NSMutableArray alloc]init];
        self.islogin = false;
    }
    return self;
}

- (void)initWithSellerDetailInfo:(SellerDetailInfoModel *)model {
    self.name = model.name;
    self.telephone = model.telephone;
    self.location = [[NSMutableDictionary alloc]initWithDictionary: model.location];
    self.cars = [[NSMutableArray alloc]initWithArray:model.cars];
    self.rate = model.rate;
    self.address = model.address;
    self.detail = model.intro;
    self.name = model.name;
    self.city = model.city;
    self.service_start_time = model.service_start_time;
    self.service_end_time = model.service_end_time;
    [self.services addObjectsFromArray:model.services];
    [self.activities addObjectsFromArray:model.activities];
    [self.images addObjectsFromArray:model.images];
    [self.comments addObjectsFromArray:model.comments];
    [self.commodities addObjectsFromArray:model.commodities];
    [self.face_images addObjectsFromArray:model.face_images];
    [self.eco_images addObjectsFromArray:model.eco_images];
    [self.internal_images addObjectsFromArray:model.internal_images];
    [self.groups addObjectsFromArray:model.groups];

}

- (void)loadDataFromNetwork:(NSString *)seller_id success:(CallSuccessBlock)success failure:(CallFailureBlock)failure {
    
    
    // call rcar service to get fault detail info
    NSDictionary *params = @{@"role":@"seller", @"seller_id":self.seller_id};
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    DCObjectMapping *imagesMaping = [DCObjectMapping mapKeyPath:@"images" toAttribute:@"images" onClass:[SellerInfoModel class]];
    DCArrayMapping *serviceMaping = [DCArrayMapping mapperForClassElements:[SellerServiceModel class] forAttribute:@"services" onClass:[SellerInfoModel class]];
    
    DCArrayMapping *activityMaping = [DCArrayMapping mapperForClassElements:[SellerActivityModel class] forAttribute:@"activities" onClass:[SellerInfoModel class]];
    DCArrayMapping *commodityMaping = [DCArrayMapping mapperForClassElements:[SellerCommodityModel class] forAttribute:@"commodities" onClass:[SellerInfoModel class]];
    DCArrayMapping *commentMaping = [DCArrayMapping mapperForClassElements:[SellerCommentModel class] forAttribute:@"comments" onClass:[SellerInfoModel class]];
    
    DCArrayMapping *groupMaping = [DCArrayMapping mapperForClassElements:[UserGroupModel class] forAttribute:@"groups" onClass:[SellerInfoModel class]];
    
    
    [config addArrayMapper:serviceMaping];
    [config addArrayMapper:activityMaping];
    [config addArrayMapper:commodityMaping];
    [config addArrayMapper:commentMaping];
    [config addObjectMapping:imagesMaping];
    [config addArrayMapper:groupMaping];
    
    
    __block SellerModel *blockself = self;
    [RCar GET:rcar_api_seller modelClass:@"SellerDetailInfoModel" config:config params:params success:^(SellerDetailInfoModel *model) {
        if (model.api_result == APIE_OK) {
            [blockself initWithSellerDetailInfo:model];
            if (success) success(nil);
        } else {
            if (failure) failure(nil);
         }
    } failure:^(NSString *errorStr) {
        if (failure) failure(errorStr);
    }];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        self.seller_id = [decoder decodeObjectForKey:@"seller_id"];
#if 0
        self.telephone = [decoder decodeObjectForKey:@"telephone"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.location = [decoder decodeObjectForKey:@"location"];
        self.detail = [decoder decodeObjectForKey:@"detail"];
        self.images = [decoder decodeObjectForKey:@"images"];
        self.face_images = [decoder decodeObjectForKey:@"face_image"];
        self.internal_images = [decoder decodeObjectForKey:@"internal_images"];
        self.eco_images = [decoder decodeObjectForKey:@"eco_images"];
        
        self.service_start_time = [decoder decodeObjectForKey:@"service_start_time"];
        self.service_end_time = [decoder decodeObjectForKey:@"service_end_time"];
        self.services = [decoder decodeObjectForKey:@"services"];
        self.activities = [decoder decodeObjectForKey:@"activities"];
        self.commodities = [decoder decodeObjectForKey:@"commodities"];
        self.comments = [decoder decodeObjectForKey:@"comments"];
        self.users = [decoder decodeObjectForKey:@"users"];
        self.orders = [decoder decodeObjectForKey:@"orders"];
        self.advertisements = [decoder decodeObjectForKey:@"advertisements"];
        self.accusations = [decoder decodeObjectForKey:@"accusations"];
        self.records = [decoder decodeObjectForKey:@"records"];
        self.cars = [decoder decodeObjectForKey:@"cars"];
        self.groups = [decoder decodeObjectForKey:@"groups"];
        self.lastUserId = [decoder decodeObjectForKey:@"lastUserId"];
        self.msgs = [decoder decodeObjectForKey:@"msgs"];
#endif
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.seller_id forKey:@"seller_id"];
#if 0
    [coder encodeObject:self.telephone forKey:@"telephone"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.city forKey:@"city"];
    [coder encodeObject:self.address forKey:@"address"];
    [coder encodeObject:self.location forKey:@"location"];
    [coder encodeObject:self.detail forKey:@"detail"];
    [coder encodeObject:self.images forKey:@"images"];
    [coder encodeObject:self.face_images forKey:@"face_image"];
    [coder encodeObject:self.internal_images forKey:@"internal_images"];
    [coder encodeObject:self.eco_images forKey:@"eco_images"];
    
    [coder encodeObject:self.service_start_time forKey:@"service_start_time"];
    [coder encodeObject:self.service_end_time forKey:@"service_end_time"];
    [coder encodeObject:self.services forKey:@"services"];
    [coder encodeObject:self.activities forKey:@"activities"];
    [coder encodeObject:self.commodities forKey:@"commodities"];
    [coder encodeObject:self.comments forKey:@"comments"];
    [coder encodeObject:self.users forKey:@"users"];
    [coder encodeObject:self.orders forKey:@"orders"];
    [coder encodeObject:self.advertisements forKey:@"advertisements"];
    [coder encodeObject:self.accusations forKey:@"accusations"];
    [coder encodeObject:self.records forKey:@"records"];
    [coder encodeObject:self.cars forKey:@"cars"];
    [coder encodeObject:self.lastUserId forKey:@"lastUserId"];
    [coder encodeObject:self.groups forKey:@"groups"];
    [coder encodeObject:self.msgs forKey:@"msgs"];
#endif
}

+ (instancetype)load {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [path stringByAppendingPathComponent:@"seller.info"];
    
    SellerModel *seller = nil;
    if (filename) {
        seller = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
        seller.islogin = NO;
        if (seller.groups == nil)
            seller.groups = [[NSMutableArray alloc]init];
        if (seller.msgs == nil)
            seller.msgs = [[NSMutableArray alloc]init];
        if (seller.services == nil)
            seller.services = [[NSMutableArray alloc]init];
        if (seller.images == nil)
            seller.images = [[NSMutableArray alloc]init];
        if (seller.face_images == nil)
            seller.face_images = [[NSMutableArray alloc]init];
        if (seller.internal_images == nil)
            seller.internal_images = [[NSMutableArray alloc]init];
        if (seller.eco_images == nil)
            seller.eco_images = [[NSMutableArray alloc]init];
        
        if (seller.commodities == nil)
            seller.commodities = [[NSMutableArray alloc]init];
        if (seller.comments == nil)
            seller.comments = [[NSMutableArray alloc]init];
        if (seller.activities == nil)
            seller.activities = [[NSMutableArray alloc]init];
        if (seller.users == nil)
            seller.users = [[NSMutableArray alloc]init];
        if (seller.orders == nil)
            seller.orders = [[NSMutableArray alloc]init];
        if (seller.advertisements == nil)
            seller.advertisements = [[NSMutableArray alloc]init];
        if (seller.accusations == nil)
            seller.accusations = [[NSMutableArray alloc]init];
        if (seller.groups == nil)
            seller.groups = [[NSMutableArray alloc]init];
        if (seller.users == nil)
            seller.users = [[NSMutableArray alloc]init];
        
        
    }
    return seller;
}

- (void)flush {
    if (self.seller_id && ![self.seller_id isEqualToString:@""]) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filename = [path stringByAppendingPathComponent:@"seller.info"];
        [NSKeyedArchiver archiveRootObject:self toFile:filename];
    }
}

- (void)addOrder:(OrderModel *)order {
    [self.orders addObject:order];
    
    NSArray *sortedArray = [self.orders sortedArrayUsingComparator:^(id obj1, id obj2) {
        OrderModel *order1 = obj1;
        OrderModel *order2 = obj2;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        NSDate *date1 = [formatter dateFromString:order1.date_time];
        NSDate *date2 = [formatter dateFromString:order2.date_time];
        
        NSComparisonResult result = [date1 compare:date2];
        switch(result) {
            case NSOrderedAscending:
                return NSOrderedDescending;
            case NSOrderedDescending:
                return NSOrderedAscending;
            case NSOrderedSame:
                return NSOrderedSame;
            default:
                return NSOrderedSame;    
        }
    }];
    [self.orders removeAllObjects];
    [self.orders addObjectsFromArray:sortedArray];
}

- (void)removeOrderById:(NSString *)order_id {
    for (OrderModel *order in self.orders) {
        if ([order.order_id isEqualToString:order_id]) {
            [self removeOrder:order];
            break;
        }
    }
    
}
- (void)removeOrder:(OrderModel *)order {
    [self.orders removeObject:order];
}

- (void)addOrders:(NSArray *)orders {
    for (OrderModel *order in orders)
         [self addOrder:order];
}

- (void)updateOrderStatus:(NSString *)order_id status:(NSString *)status {
    for (OrderModel *order in self.orders) {
        if (order.order_id != nil && [order.order_id isEqualToString:order_id]) {
            order.status = status;
            break;
        }
    }
}

- (void)setPushId:(NSString *)userId channelId:(NSString *)channelId {
    self.pushUserId = [NSString stringWithString:userId];
    self.pushChannelId = [NSString stringWithString:channelId];
    
    if (self.islogin == YES) {
        NSDictionary *params = @{@"role":@"seller", @"seller_id":self.seller_id, @"pwd":self.pwd,
                                 @"push_user_id":self.pushUserId, @"push_channel_id":self.pushChannelId };
        
        [RCar POST:rcar_api_seller_session  modelClass:nil config:nil  params:params success:nil failure:nil];
    }
}


-(NSString *)getPushUserId {
    return self.pushUserId;
}
-(NSString *)getPushChannelId {
    return self.pushChannelId;
}





@end