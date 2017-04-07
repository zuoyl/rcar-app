//
//  RecentModel.m
//  CarSeller
//
//  Created by jenson.zuo on 15/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "RecentModel.h"
#import "sqlite3.h"

@implementation RecentModel {

}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        self.type = [decoder decodeObjectForKey:@"type"];
        self.itemId = [decoder decodeObjectForKey:@"itemId"];
        self.date = [decoder decodeObjectForKey:@"date"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.itemId forKey:@"itemId"];
    [coder encodeObject:self.date forKey:@"date"];
}

@end

