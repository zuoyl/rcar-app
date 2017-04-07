//
//  ActivityModel.m
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerActivityModel.h"

@implementation SellerActivityModel

-(void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.activity_id forKey:@"id"];
    [coder encodeObject:self.status forKey:@"status"];
    [coder encodeObject:self.url forKey:@"url"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.detail forKey:@"detail"];
    [coder encodeObject:self.start_date forKey:@"start"];
    [coder encodeObject:self.end_date forKey:@"end"];
    [coder encodeObject:self.images forKey:@"images"];
}

-(id) initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.activity_id = [decoder decodeObjectForKey:@"id"];
        self.status = [decoder decodeObjectForKey:@"status"];
        self.url = [decoder decodeObjectForKey:@"url"];
        self.detail = [decoder decodeObjectForKey:@"detail"];
        self.start_date = [decoder decodeObjectForKey:@"start"];
        self.end_date = [decoder decodeObjectForKey:@"end"];
        self.images = [decoder decodeObjectForKey:@"images"];
    }
    return self;
}

@end
