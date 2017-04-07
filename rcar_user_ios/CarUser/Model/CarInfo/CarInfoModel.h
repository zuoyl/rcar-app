//
//  CarInfoModel.h
//  CarUser
//
//  Created by huozj on 1/26/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CarInfoModel : APIResponseModel

@property (nonatomic, strong) NSString *kind;  // 车系
@property (nonatomic, strong) NSString *brand; // 车型
@property (nonatomic, strong) NSString *year;  // 年款
@property (nonatomic, strong) NSString *platenumber; //车牌号码
@property (nonatomic, strong) NSString *buy_date; //出厂日期
@property (nonatomic, strong) NSString *miles; //行驶里程
@property (nonatomic, strong) NSString *insurance; //行驶里程

//- (id)initWithCoder:(NSCoder *)decoder;
//- (void)encodeWithCoder:(NSCoder *)coder;

@end

