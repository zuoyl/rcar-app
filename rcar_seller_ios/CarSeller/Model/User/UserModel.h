//
//  UserModel.h
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    USER_ADD_WAITING,
    USER_ADD_RETRY,
    USER_ADD_COMPLETE
};

@interface UserModel : APIResponseModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, assign, getter = isVip) BOOL vip;
@property (nonatomic, strong) NSString *car_no;
@property (nonatomic, strong) NSString *car_kind;
@property (nonatomic, strong) NSString *car_type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL online;
@property (nonatomic, strong) NSString *car_miles;
@property (nonatomic, strong) NSString *memo;

+ (instancetype)userWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;


@end
