//
//  OrderDetailModel.h
//  CarSeller
//
//  Created by jenson.zuo on 11/8/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "OrderModel.h"

@interface OrderDetailModel : OrderModel
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSString *cost;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *feedback;
@property (nonatomic, strong) NSDictionary *reply;

@end
