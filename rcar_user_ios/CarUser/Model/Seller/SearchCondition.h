//
//  SearchCondition.h
//  CarUser
//
//  Created by huozj on 1/28/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchCondition : NSObject

@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *sellerType;
@property (nonatomic, strong) NSNumber *sortType;

@end
