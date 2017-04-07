//
//  FaultReportReplyModel.h
//  CarUser
//
//  Created by jenson.zuo on 18/5/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaultReportReplyModel : NSObject
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *price;
@end
