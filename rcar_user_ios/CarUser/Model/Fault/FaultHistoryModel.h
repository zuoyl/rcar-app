//
//  FaultHistoryModel.h
//  CarSeller
//
//  Created by jenson.zuo on 29/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FaultStatusNew = 0,
    FaultStatusProcessing,
    FaultStatusFinished
} FaultStatus;


@interface FaultHistoryModel : NSObject

@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *cost;
@property (nonatomic, strong) NSString *seller;

@end
