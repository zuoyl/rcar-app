//
//  OrderDetailModel.h
//  CarUser
//
//  Created by jenson.zuo on 6/8/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"

@interface OrderDetailModel : OrderModel

@property (nonatomic, strong) NSDictionary *detail;
@property (nonatomic, strong) NSDictionary *replies;

@end
