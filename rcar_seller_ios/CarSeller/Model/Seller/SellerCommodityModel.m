//
//  CommodityModel.m
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerCommodityModel.h"

@implementation SellerCommodityModel

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        self.commodity_id = [decoder decodeObjectForKey:@"cid"];
        self.seller_id = [decoder decodeObjectForKey:@"seller_id"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.detail = [decoder decodeObjectForKey:@"detail"];
        self.rate = [decoder decodeObjectForKey:@"rate"];
        self.brand = [decoder decodeObjectForKey:@"band"];
        self.cutoff = [decoder decodeObjectForKey:@"cutoff"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.commodity_id forKey:@"commodity_id"];
    [coder encodeObject:self.seller_id forKey:@"seller_id"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.detail forKey:@"desc"];
    [coder encodeObject:self.rate forKey:@"rate"];
    [coder encodeObject:self.brand forKey:@"band"];
    [coder encodeObject:self.cutoff forKey:@"cutoff"];
 }

@end
