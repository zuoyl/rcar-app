//
//  ServicePublicateModel.h
//  CarUser
//
//  Created by huozj on 2/11/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarInfoModel.h"

@interface ServicePublicateModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) CarInfoModel *car;
@property (nonatomic, strong) NSString *platenumber;
@property (nonatomic, strong) NSString *mileage;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSMutableArray *serviceList;
@property (nonatomic, strong) NSString *scope; 
@property (nonatomic, strong) NSMutableArray *sellerList;
@property (nonatomic, strong) NSMutableDictionary *items;
@property (nonatomic, strong) NSMutableDictionary *condtions;


@end
