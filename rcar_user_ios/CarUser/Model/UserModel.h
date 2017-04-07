//
//  sellerSession.h
//
//  Created by Jenson.Zuo on 14-11-4.
//  Copyright (c) 2014年 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"


@interface UserModel : NSObject

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) UserInfoModel *info;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSMutableArray *faultReportReplies;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, strong) NSMutableArray *cars;
@property (nonatomic, strong) NSMutableArray *msgs;

+ (UserModel*)sharedClient;
- (BOOL) isLogin;
- (void) setLoginStatus:(BOOL)status;
- (void) clearAllData;

- (void)setPushId:(NSString *)userId channelId:(NSString *)channelId;
-(NSString *)getPushUserId;
-(NSString *)getPushChannelId;
@end
