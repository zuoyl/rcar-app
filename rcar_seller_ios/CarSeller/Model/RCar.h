//
//  RCar.h
//  CarSeller
//
//  Created by jenson.zuo on 30/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCArrayMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "APIResponseModel.h"


// seller
#define rcar_api_seller                                 @"seller/"
#define rcar_api_seller_session                         @"seller/session"
#define rcar_api_seller_pwd                             @"seller/pwd"


// comment
#define rcar_api_seller_commodity_list                  @"seller/commodity-list"
#define rcar_api_seller_comment_list                    @"seller/comment-list"
#define rcar_api_seller_comment                         @"seller/comment"

// user management
#define rcar_api_seller_user_list                       @"seller/user-list"
#define rcar_api_seller_user                            @"seller/user"
#define rcar_api_seller_user_group                      @"seller/user-group"

// message
#define rcar_api_seller_user_msg                        @"seller/user-message"
#define rcar_api_seller_group_msg                       @"seller/group-message"
#define rcar_api_seller_user_msg_list                   @"seller/user-message-list"
#define rcar_api_seller_group_msg_list                  @"seller/group-message-list"

// order
#define rcar_api_seller_order_list                      @"seller/order-list"
#define rcar_api_seller_order                           @"seller/order"

// activity
#define rcar_api_seller_activity_list                   @"seller/activity-list"
#define rcar_api_seller_activity                        @"seller/activity"

// service
#define rcar_api_seller_service_list                    @"seller/service-list"
#define rcar_api_seller_service                         @"seller/service"

// /commodity
#define rcar_api_seller_commodity                       @"seller/commodity"
#define rcar_api_seller_commodity_list                  @"seller/commodity-list"

// accusation
#define rcar_api_seller_accusation_list                 @"seller/accusation-list"
#define rcar_api_seller_accusation                      @"seller/accusation"

// advertisement
#define rcar_api_seller_advertisement                   @"seller/advertisement"
#define rcar_api_seller_advertisement_list              @"seller/advertisement-list"
#define rcar_api_seller_ads                             @"seller/ads"

// suggestion
#define rcar_api_seller_suggestion                      @"seller/suggestion"


enum {
    APIE_OK = 0,
    APIE_CLIENT_INTERNAL,
    APIE_NO_CONNECTION,
    APIE_INVALID_CLIENT_REQ,
    APIE_INVALID_PARAM,
    APIE_SERVER_INTERNAL,
    APIE_USER_ALREADY_EXIST,
    APIE_SELLER_ALREADY_EXIST,
    APIE_NO_SERVICE,
    APIE_USER_NO_EXIST,
    APIE_SELLER_NO_EXIST,
    APIE_COMMODITY_NO_EXIST,
    APIE_MAINTENANCE_NO_EXIST,
    APIE_PWD_ERROR,
    APIE_MAX
};

typedef void(^CallSuccessBlock)(id result);
typedef void(^CallFailureBlock)(NSString *errorStr);


@interface RCar : NSObject
+ (RCar*)sharedClient;

+ (NSString *)aplServer;
+ (NSString *)imageServer;

+ (void)GET:(NSString*)serviceName
 modelClass:(NSString *)modelClass
     config:(DCParserConfiguration *)config
     params:(NSDictionary *)params
    success:(CallSuccessBlock)success
    failure:(CallFailureBlock)failure;

+ (void)POST:(NSString*)serviceName
  modelClass:(NSString *)modelClass
      config:(DCParserConfiguration *)config
      params:(NSDictionary *)params
     success:(CallSuccessBlock)success
     failure:(CallFailureBlock)failure;

+ (void)DELETE:(NSString*)serviceName
    modelClass:(NSString *)modelClass
        config:(DCParserConfiguration *)config
        params:(NSDictionary *)params
       success:(CallSuccessBlock)success
       failure:(CallFailureBlock)failure;

+ (void)PUT:(NSString*)serviceName
 modelClass:(NSString *)modelClass
     config:(DCParserConfiguration *)config
     params:(NSDictionary *)params
    success:(CallSuccessBlock)success
    failure:(CallFailureBlock)failure;

+ (void)callBaiduGeocoder:(NSNumber *)lat lng:(NSNumber *)lng
                  success:(CallSuccessBlock)success
                  failure:(CallFailureBlock)failure;

+ (void)uploadImage:(NSArray *)images names:(NSArray *)names target:(NSString*)target success:(CallSuccessBlock)success failure:(CallFailureBlock)failure;


+ (BOOL) isConnected;
@end
