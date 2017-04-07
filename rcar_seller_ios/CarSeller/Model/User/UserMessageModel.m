//
//  UserMessageModel.m
//  CarSeller
//
//  Created by jenson.zuo on 24/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "UserMessageModel.h"

@implementation UserMessageModel

+ (id)messageModelWithDict:(NSDictionary *)dict {
    UserMessageModel *message = [[self alloc] init];
    message.content = dict[@"text"];
    message.time = dict[@"time"];
   // message.type = [dict[@"type"] intValue];
    return message;
}

@end
