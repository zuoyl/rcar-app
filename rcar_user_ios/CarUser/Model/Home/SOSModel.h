//
//  SOSModel.h
//  CarSeller
//
//  Created by jenson.zuo on 16/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    SOS_Status_None,
    SOS_Status_Waiting,
    SOS_Status_Waiting_NoDisplay,
};

@interface SOSModel : NSObject

@property (nonatomic, strong) NSString *sos_id;
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSMutableArray *replies;


@end
