//
//  SOSModel.m
//  CarSeller
//
//  Created by jenson.zuo on 16/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SOSModel.h"

@implementation SOSModel
@synthesize sos_id;
@synthesize replies;


- (instancetype)init {
    self = [super init];
    self.sos_id = nil;
    self.replies = [[NSMutableArray alloc] init];
    return self;
}

@end
