//
//  RegisterModel.h
//  CarSeller
//
//  Created by jenson.zuo on 29/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationModel.h"

typedef enum {
    RegisterModelStep1 = 0,
    RegisterModelStep2,
    RegisterModelFinished,
} RegisterModelStep;

@interface RegisterModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pwd;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *verify_code;
@property (nonatomic, assign) NSInteger step;
@property (nonatomic, strong) NSMutableArray *album1;
@property (nonatomic, strong) NSMutableArray *album2;
@property (nonatomic, strong) NSMutableArray *album3;
@property (nonatomic, strong) NSMutableArray *services;
@property (nonatomic, strong) NSMutableArray *cars;
@property (nonatomic, strong) NSString *serviceStartTime;
@property (nonatomic, strong) NSString *serviceEndTime;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSMutableDictionary *location;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *carText;

@property (nonatomic, strong) NSString *seller_id;

+ (RegisterModel *)sharedClient;

@end


@interface RegisterRspModel : APIResponseModel
@property (nonatomic, strong) NSString *seller_id;
@end
