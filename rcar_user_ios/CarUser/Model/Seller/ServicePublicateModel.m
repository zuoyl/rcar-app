//
//  ServicePublicateModel.m
//  CarUser
//
//  Created by huozj on 2/11/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "ServicePublicateModel.h"

@implementation ServicePublicateModel

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.serviceList = [[NSMutableArray alloc] init];
        self.sellerList = [[NSMutableArray alloc] init];
        self.items = [[NSMutableDictionary alloc]init];
        self.condtions = [[NSMutableDictionary alloc] init];
    }
    return self;
}


@end
