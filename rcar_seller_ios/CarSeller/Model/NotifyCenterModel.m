//
//  NotifyCenterModel.m
//  CarSeller
//
//  Created by jenson.zuo on 16/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "NotifyCenterModel.h"
#import "MessageModel.h"

@implementation NotifyCenterModel;

@synthesize total;
@synthesize orders;

+ (NotifyCenterModel *)sharedClient {
    static NotifyCenterModel *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NotifyCenterModel alloc] init];
        
    });
    return _sharedClient;
    
}

- (instancetype)init {
    self = [super init];
    self.orders = [[NSMutableArray alloc]init];
    self.accustions = [[NSMutableArray alloc]init];
    self.sos = [[NSMutableArray alloc]init];
    self.msgs = [[NSMutableArray alloc]init];
    self.notifications = [[NSMutableArray alloc]init];
    return self;
}

- (BOOL)load {
    return true;
    
}


- (void)flush {
    
}

- (void)clearCache {
    
}
- (void)deleteItem:(NSString *)kind identifier:(NSString *)identifier {
    
}

- (void)push:(NSMutableDictionary *)data {
    
}

- (void)handleRemoteNotification:(NSDictionary *)notify {
    NSString *kind = [notify objectForKey:@"kind"];
    
    if ([kind isEqualToString:RCarNotificationKindMsg])
        [[self mutableArrayValueForKey:@"msgs"] addObject:notify];
    
    else if ([kind isEqualToString:RCarNotificationKindOrder]) {
        [[self mutableArrayValueForKey:@"orders"] addObject:notify];
    }
}

@end