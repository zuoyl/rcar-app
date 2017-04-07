//
//  UserMessageModel.h
//  CarSeller
//
//  Created by jenson.zuo on 24/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MessageTypeMe = 0,
    MessageTypeOther,
} MessageType;

@interface UserMessageModel : APIResponseModel
@property (nonatomic, strong) NSString *msg_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSArray *to;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, assign) NSInteger flag;

+ (id)messageModelWithDict:(NSDictionary *)dict;


@end
