//
//  MessageModel.h
//  CarUser
//
//  Created by jenson.zuo on 15/1/2016.
//  Copyright © 2016 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RCarNotificationSourceSystem                    @"sys"
#define RCarNotificationSourceSeller                    @"seller"
#define RCarNotificationSourceUser                      @"user"

#define RCarNotificationKindSOS                         @"sos"
#define RCarNotificationKindOrder                       @"order"
#define RCarNotificationKindMsg                         @"msg"
#define RCarNotificationKindAccusation                  @"accusation"
#define RCarNotificationKindActivity                    @"activity"

@interface MessageModel : NSObject
@property (nonatomic, strong) NSString *msgid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *replyable;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *seller_id;

@end

@interface MessageDetailModel : MessageModel
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSMutableArray *replies;

@end


@interface MessageRepleyModel : NSObject
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *seller_name;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSString *content;
@end
