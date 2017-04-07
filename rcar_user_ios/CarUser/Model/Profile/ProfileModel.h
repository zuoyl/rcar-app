//
//  ProfileModel.h
//  CarSeller
//
//  Created by jenson.zuo on 9/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIResponseModel.h"

@interface ProfileModel : APIResponseModel
@property (nonatomic, strong) NSString *user_name;
//@property (nonatomic, strong) NSString *car_name;
@property (nonatomic, strong) NSString *image;
//@property (nonatomic, strong) NSString *car_image;
@property (nonatomic, strong) NSString *fault_count;
@property (nonatomic, strong) NSString *insurance;
@property (nonatomic, strong) NSString *insurance_url;
@property (nonatomic, strong) NSString *credits;
@property (nonatomic, strong) NSString *coupons;

@end
