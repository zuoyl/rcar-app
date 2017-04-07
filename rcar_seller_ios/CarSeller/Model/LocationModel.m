//
//  LocationModel.m
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "LocationModel.h"

@implementation LocationModel


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        self.lat = [[decoder decodeObjectForKey:@"lat"] longValue];
        self.lng = [[decoder decodeObjectForKey:@"lng"] longValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[NSNumber numberWithDouble:self.lat] forKey:@"lat"];
    [coder encodeObject:[NSNumber numberWithDouble:self.lng] forKey:@"lng"];
}

@end
