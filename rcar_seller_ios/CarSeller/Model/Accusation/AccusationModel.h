//
//  AccusationModel.h
//  CarSeller
//
//  Created by jenson.zuo on 27/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString * const kAccusationStatusNew = @"new";
static NSString * const kAccusationStatusCompleted = @"completed";
static NSString * const kAccusationStatusSellerWait = @"seller_wait";
static NSString * const kAccusationStatusSystemWait = @"sys_wait";
static NSString * const kAccusationStatusUnknown = @"unknown";





@interface AccusationModel : APIResponseModel <NSCoding>
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *accusation_id;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_type;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *replies;
@end

@interface AccusationReplyModel : NSObject
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *content;
@end
