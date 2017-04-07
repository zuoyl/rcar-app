//
//  DataArrayModel.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-15.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIResponseModel.h"

@interface DataArrayModel : APIResponseModel
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSArray *data;

@end
