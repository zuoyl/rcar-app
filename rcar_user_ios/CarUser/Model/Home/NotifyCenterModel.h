//
//  NotifyCenterModel.h
//  CarSeller
//
//  Created by jenson.zuo on 16/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOSModel.h"
#import "ActivityNotifyModel.h"
#import "FaultNotifyModel.h"

@interface NotifyCenterModel : NSObject
@property (nonatomic, strong) NSMutableArray *sos;
@property (nonatomic, strong) NSMutableArray *notifications;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, strong) NSMutableArray *msgs;

+ (NotifyCenterModel *)sharedClient;
- (BOOL)load;
- (void)flush;
- (void)clearCache;
- (void)deleteItem:(NSString *)kind identifier:(NSString *)identifier;
- (void)push:(NSMutableDictionary *)data;
- (void)handleRemoteNotification:(NSDictionary *)notify;

@end
