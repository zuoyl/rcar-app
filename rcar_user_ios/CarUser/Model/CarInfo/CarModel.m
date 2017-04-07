//
//  CarModel.m
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel

@end


@implementation CarTypeListModel

+ (instancetype)getInstance {
    static CarTypeListModel *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CarTypeListModel alloc] init];
        [_sharedClient load];
        
    });
    return _sharedClient;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        //self.cars = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)load {
    if (self.cars == nil) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"cars" ofType:@"plist"];
        self.cars = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    }
}


@end