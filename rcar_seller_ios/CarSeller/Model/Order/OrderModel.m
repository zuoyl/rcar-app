//
//  OrderModel.m
//  CarSeller
//
//  Created by jenson.zuo on 25/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "OrderModel.h"


@implementation OrderModel

@synthesize id;
@synthesize read;

#if 0
- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self != nil) {
        self.order_id = [dict objectForKey:@"id"];
        self.type = [dict objectForKey:@"type"];
        self.title = [dict objectForKey:@"title"];
        self.address = [dict objectForKey:@"address"];
        self.distance = [dict objectForKey:@"distance"];
        self.detail = [dict objectForKey:@"detail"];
    }
    return self;
}
#endif

@end





