//
//  AdvertisementModel.m
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-14.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AdvertisementModel.h"

@implementation AdvertisementModel

-(void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.ads_id forKey:@"id"];
    [coder encodeObject:self.seller_id forKey:@"seller_id"];
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.link forKey:@"link"];
    [coder encodeObject:self.start_time forKey:@"start"];
    [coder encodeObject:self.end_time forKey:@"end"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.detail forKey:@"detail"];
    [coder encodeObject:self.images forKey:@"images"];
}

-(id) initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.ads_id = [decoder decodeObjectForKey:@"id"];
        self.seller_id = [decoder decodeObjectForKey:@"seller_id"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.link = [decoder decodeObjectForKey:@"link"];
        self.start_time = [decoder decodeObjectForKey:@"start"];
        self.end_time = [decoder decodeObjectForKey:@"end"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.detail = [decoder decodeObjectForKey:@"detail"];
        self.images = [decoder decodeObjectForKey:@"images"];
    }
    return self;
}

@end

@implementation AdvertisementRspModel

@end

