//
//  SellerServiceItemModel.m
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerServiceModel.h"

@implementation SellerServiceModel

@end

@implementation ServiceContactModel

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.items = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
