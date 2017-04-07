//
//  RecommendModel.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-15.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendModel : NSObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *addr;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) BOOL read;
@end
