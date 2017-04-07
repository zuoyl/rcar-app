//
//  CouponModel.h
//  CarSeller
//
//  Created by jenson.zuo on 9/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *start_date;
@property (nonatomic, strong) NSString *end_date;
@property (nonatomic, strong) NSString *status;

@end
