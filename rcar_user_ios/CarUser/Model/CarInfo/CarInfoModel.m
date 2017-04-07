//
//  CarInfoModel.m
//  CarUser
//
//  Created by huozj on 1/26/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "CarInfoModel.h"


@implementation CarInfoModel

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.brand = @""; //车辆型号
        self.platenumber = @""; //车牌号码
        self.buy_date = @""; //出厂日期
        self.miles = @""; //行驶里程
    }
    return self;
}
/*
 - (id)initWithCoder:(NSCoder *)decoder {
 self = [super init];
 if (self != nil) {
 self.brand = [decoder decodeObjectForKey:@"brand"];; //车辆型号
 self.number = [decoder decodeObjectForKey:@"number"];; //车牌号码
 self.date = [decoder decodeObjectForKey:@"date"];; //出厂日期
 self.mileage = [decoder decodeObjectForKey:@"mileage"];; //行驶里程
 }
 
 return self;
 }
 
 - (void)encodeWithCoder:(NSCoder *)coder {
 [coder encodeObject:self.brand forKey:@"brand"];
 [coder encodeObject:self.number forKey:@"number"];
 [coder encodeObject:self.date forKey:@"date"];
 [coder encodeObject:self.mileage forKey:@"mileage"];
 }
 */

@end

