//
//  AccusationModel.m
//  CarSeller
//
//  Created by jenson.zuo on 27/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "AccusationModel.h"

@implementation AccusationModel

-(void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.accusation_id forKey:@"id"];
    [coder encodeObject:self.status forKey:@"status"];
    [coder encodeObject:self.date forKey:@"date"];
    [coder encodeObject:self.user_id forKey:@"user"];
    [coder encodeObject:self.seller_id forKey:@"seller"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.detail forKey:@"detail"];
    [coder encodeObject:self.images forKey:@"images"];
    [coder encodeObject:self.replies forKey:@"replies"];
    
}

-(id) initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.accusation_id = [decoder decodeObjectForKey:@"id"];
        self.status = [decoder decodeObjectForKey:@"status"];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.user_id = [decoder decodeObjectForKey:@"user"];
        self.seller_id = [decoder decodeObjectForKey:@"seller"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.detail = [decoder decodeObjectForKey:@"detail"];
        self.images = [decoder decodeObjectForKey:@"images"];
        self.replies = [decoder decodeObjectForKey:@"replies"];
        
    }
    return self;
}


@end
