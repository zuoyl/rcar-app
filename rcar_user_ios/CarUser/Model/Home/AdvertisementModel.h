//
//  AdvertisementModel.h
//  CarSeller
//
//  Created by Jenson.Zuo on 14-11-14.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AdvertisementModel : NSObject
@property (nonatomic, strong) NSString *ads_id;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *images;
@end

