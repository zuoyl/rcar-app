//
//  OrderModel.m
//  CarUser
//
//  Created by jenson.zuo on 5/8/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
@synthesize id;
@synthesize read;

@end




@implementation ServiceInfoList

+ (instancetype)shared {
    static ServiceInfoList *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ServiceInfoList alloc] init];
        
    });
    return _sharedClient;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.types = [[NSMutableArray alloc]initWithArray: @[kServiceType_CarMaintenance, @"钣金喷漆", @"汽车装潢", @"轮胎置换", kServiceType_CarSos, @"上门服务"]];
    }
    return self;
}

+ (NSString *)imageNameOfService:(NSString *)service {
    NSDictionary *images = @{kServiceType_CarMaintenance:@"bus", @"钣金喷漆":@"bus", @"汽车装潢":@"bus", @"轮胎置换":@"bus", kServiceType_CarSos:@"bus", @"上门服务":@"bus"};
    
    if ([images objectForKey:service] == nil)
         return @"bus";
     else
         return [images objectForKey:service];
}

@end
