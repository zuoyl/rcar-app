//
//  SearchCondition.m
//  CarUser
//
//  Created by huozj on 1/28/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "SearchCondition.h"

@implementation SearchCondition


- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.distance = [[NSNumber alloc] init];
        self.sellerType = [[NSNumber alloc] init];
        self.sortType = [[NSNumber alloc] init];
    }
    return self;
}


@end
