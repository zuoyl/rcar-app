//
//  FaultDetailModel.h
//  CarSeller
//
//  Created by jenson.zuo on 29/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIResponseModel.h"

@interface FaultDetailModel : APIResponseModel

@property (nonatomic, strong) NSString *business_id;
@property (nonatomic, strong) NSString *fault_status;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *insurance;
@property (nonatomic, strong) NSString *insurance_man;
@property (nonatomic, strong) NSString *repair;
@property (nonatomic, strong) NSString *cost;
@property (nonatomic, strong) NSString *seller;
@property (nonatomic, strong) NSString *estimate;
@property (nonatomic, strong) NSMutableArray *images;

@end
