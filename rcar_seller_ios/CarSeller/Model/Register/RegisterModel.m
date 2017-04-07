//
//  RegisterModel.m
//  CarSeller
//
//  Created by jenson.zuo on 29/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "RegisterModel.h"

@implementation RegisterModel

+ (instancetype)sharedClient {
    static RegisterModel *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[RegisterModel alloc] init];
        
    });
    return _sharedClient;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.album1 = [[NSMutableArray alloc]init];
        self.album2 = [[NSMutableArray alloc]init];
        self.album3 = [[NSMutableArray alloc]init];
        self.services = [[NSMutableArray alloc]init];
        self.cars = [[NSMutableArray alloc]init];
    }
    return self;
}

@end


@implementation RegisterRspModel

@end