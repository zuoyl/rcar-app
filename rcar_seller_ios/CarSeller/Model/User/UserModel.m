//
//  UserModel.m
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (instancetype)userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        //[self setValuesForKeysWithDictionary:dict];
        self.name = [dict objectForKey:@"name"];
        self.user_id = [dict objectForKey:@"user_id"];
    }
    return self;
}

@end
