//
//  sellerSession.m
//  rcar_sdk
//
//  Created by Jenson.Zuo on 14-11-4.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import "UserModel.h"


@interface UserModel()
@property (nonatomic, assign) BOOL isLogined;
@property (nonatomic, strong) NSString *pushUserId;
@property (nonatomic, strong) NSString *pushChannelId;
@end

@implementation UserModel

+ (UserModel *)sharedClient {
    static UserModel *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[UserModel alloc] init];
    });
    return _sharedClient;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.user_id = @"";
        self.isLogined = NO;
        self.pushUserId = @"";
        self.pushChannelId = @"";
        self.info = [[UserInfoModel alloc]init];
        self.selectedCity = @"大连市";
        self.location = [[CLLocation alloc]init];
        self.faultReportReplies = [[NSMutableArray alloc]init];
        self.orders = [[NSMutableArray alloc]init];
        self.cars = [[NSMutableArray alloc]init];
        self.msgs = [[NSMutableArray alloc]init];
    }
    return self;
}

- (BOOL)isLogin {
    return self.isLogined;
}
- (void)setLoginStatus:(BOOL)status {
    self.isLogined = status;
}

- (void) clearAllData {
    self.user_id = @"";
    self.isLogined = NO;
    self.pushUserId = @"";
    self.pushChannelId = @"";
    self.info = [[UserInfoModel alloc]init];
    self.selectedCity = @"大连市";
    [self.faultReportReplies removeAllObjects];
    [self.orders removeAllObjects];
    [self.cars removeAllObjects];
    
    
}

- (void)setPushId:(NSString *)userId channelId:(NSString *)channelId {
    self.pushUserId = [NSString stringWithString:userId];
    self.pushChannelId = [NSString stringWithString:channelId];
}
-(NSString *)getPushUserId {
    return self.pushUserId;
}
-(NSString *)getPushChannelId {
    return self.pushChannelId;
}

@end