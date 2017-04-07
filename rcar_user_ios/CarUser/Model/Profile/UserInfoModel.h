//
//  UserInfoModel.h
//  CarSeller
//
//  Created by jenson.zuo on 9/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationModel.h"

@interface UserInfoModel : APIResponseModel
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *home_city;
@property (nonatomic, strong) NSString *home_addr;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *home_address;
@property (nonatomic, strong) NSString *company_address;
@property (nonatomic, strong) LocationModel *home_location;
@property (nonatomic, strong) LocationModel *company_location;
@property (nonatomic, strong) NSArray *cars;
@property (nonatomic, strong) NSString *image;

@end
