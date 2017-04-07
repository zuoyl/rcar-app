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
        self.cid = [decoder decodeObjectForKey:@"cid"];
        self.seller_id = [decoder decodeObjectForKey:@"seller_id"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
        self.price = [decoder decodeObjectForKey:@"price"];
        self.images = [decoder decodeObjectForKey:@"images"];
        self.rate = [decoder decodeObjectForKey:@"rate"];
        self.band = [decoder decodeObjectForKey:@"band"];
        self.cutoff = [decoder decodeObjectForKey:@"cutoff"];
        self.comments = [decoder decodeObjectForKey:@"comments"];
        self.left = [decoder decodeObjectForKey:@"left"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.cid forKey:@"cid"];
    [coder encodeObject:self.seller_id forKey:@"seller_id"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.desc forKey:@"desc"];
    [coder encodeObject:self.price forKey:@"price"];
    [coder encodeObject:self.images forKey:@"images"];
    [coder encodeObject:self.rate forKey:@"rate"];
    [coder encodeObject:self.band forKey:@"band"];
    [coder encodeObject:self.cutoff forKey:@"cutoff"];
    [coder encodeObject:self.comments forKey:@"comments"];
    [coder encodeObject:self.left forKey:@"left"];
 }

@end
