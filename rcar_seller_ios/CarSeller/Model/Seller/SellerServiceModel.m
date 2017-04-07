//
//  SellerServiceItemModel.m
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerServiceModel.h"
#import "OrderModel.h"

@implementation SellerServiceModel
- (instancetype)init {
    self = [super init];
    if (self != nil) {
        //self.images = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.price forKey:@"price"];
    [coder encodeObject:self.detail forKey:@"detail"];
   // [coder encodeObject:self.seller_id forKey:@"seller_id"];
    [coder encodeObject:self.service_id forKey:@"service_id"];
}

-(id) initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.type = [decoder decodeObjectForKey:@"type"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.detail = [decoder decodeObjectForKey:@"detail"];
        self.price = [decoder decodeObjectForKey:@"price"];
   //   self.seller_id = [decoder decodeObjectForKey:@"seller_id"];
        self.service_id = [decoder decodeObjectForKey:@"service_id"];
    }
    return self;
}

@end



@implementation SellerServiceInfoList

+ (instancetype)shared {
    static SellerServiceInfoList *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SellerServiceInfoList alloc] init];
        
    });
    return _sharedClient;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.types = [[NSMutableArray alloc]initWithArray: @[kServiceType_CarClean, kServiceType_CarFault, kServiceType_CarMaintenance, @"钣金喷漆", @"汽车装潢", @"轮胎置换", kServiceType_CarSos, @"上门服务", @"其他"]];
    }
    return self;
}

+ (NSString *)imageNameOfService:(NSString *)service {
    NSDictionary *images = @{kServiceType_CarClean:@"bus", kServiceType_CarFault:@"bus", kServiceType_CarMaintenance:@"bus", @"钣金喷漆":@"bus", @"汽车装潢":@"bus", @"轮胎置换":@"bus", kServiceType_CarSos:@"bus", @"上门服务":@"bus", @"其他":@"bus"};
    
    return [images objectForKey:service];
}


@end


