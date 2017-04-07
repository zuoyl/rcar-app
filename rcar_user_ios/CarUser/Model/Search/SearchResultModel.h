//
//  SearchResultModel.h
//  CarSeller
//
//  Created by huozj on 14-11-21.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uuid;
//@property (nonatomic, strong) NSMutableDictionary *location;
@property (nonatomic, strong) NSString *addr;
@property (nonatomic, strong) NSString *intro;
@end

