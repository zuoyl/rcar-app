//
//  ActivityModel.h
//  CarSeller
//
//  Created by jenson.zuo on 16/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject

@property (nonatomic, strong) NSString *activity_id;
@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *start_date;
@property (nonatomic, strong) NSString *end_date;
@property (nonatomic, strong) NSString *image;

@end
