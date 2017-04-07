//
//  BusinessStatusModel.h
//  CarUser
//
//  Created by jenson.zuo on 28/7/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderStatusModel : NSObject
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *cost;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSDictionary *location;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSArray *images;
@end
