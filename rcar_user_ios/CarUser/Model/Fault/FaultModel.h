//
//  FaultDetailModel.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-21.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaultModel : NSObject
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *date_time;
@property (nonatomic, strong) NSString *publicate_time;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *platenumber;
@property (nonatomic, assign) BOOL touser;
@property (nonatomic, strong) NSMutableDictionary *location;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *target_sellers;
@property (nonatomic, strong) NSMutableDictionary *condtion;
@property (nonatomic, strong) NSArray *images;
@end

