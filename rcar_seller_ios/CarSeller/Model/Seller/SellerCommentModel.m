//
//  SellerCommentModel.m
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerCommentModel.h"


@implementation SellerCommentModel

-(void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.time forKey:@"time"];
    [coder encodeObject:self.user forKey:@"user"];
    [coder encodeObject:self.content forKey:@"content"];
   // [coder encodeObject:self.image_url forKey:@"image_url"];
    
    
}

-(id) initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.time = [decoder decodeObjectForKey:@"time"];
        self.user = [decoder decodeObjectForKey:@"user"];
        self.content = [decoder decodeObjectForKey:@"content"];
     //   self.image_url = [decoder decodeObjectForKey:@"image_url"];
    }
    return self;
}

@end
