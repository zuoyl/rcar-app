//
//  RCar.h
//  CarSeller
//
//  Created by jenson.zuo on 30/11/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIResponseModel.h"


// the following are not restful apis

// for user
#define rcar_api_user                               @"user/"
#define rcar_api_user_session                       @"user/session"
#define rcar_api_user_advertisement                 @"user/advertisement"
#define rcar_api_user_recommends                    @"user/recommendations"
#define rcar_api_user_seller_list                   @"user/seller-list"
#define rcar_api_user_activity                      @"user/activity"
#define rcar_api_user_sos                           @"user/publicate_sos"
#define rcar_api_user_credit_list                   @"user/credit-list"

#define rcar_api_user_seller                        @"user/seller"
#define rcar_api_user_seller_comment_list           @"user/seller-comment-list"
#define rcar_api_user_seller_activity_list          @"user/seller-activity-list"
#define rcar_api_user_seller_commodity_list         @"user/seller-commodity-list"

#define rcar_api_user_seller_service_list           @"user/seller-service-list"
#define rcar_api_user_seller_comment                @"user/seller-comment"
#define rcar_api_user_seller_service                @"user/seller-service"

#define rcar_api_user_profile                       @"user/profile"
#define rcar_api_user_coupon_list                   @"user/coupon-list"
#define rcar_api_user_car                           @"user/car"
#define rcar_api_user_car_list                      @"user/car-list"
#define rcar_api_user_car_maintenance_info          @"user/car-maintenance-info"
#define rcar_api_user_favorite                      @"user/favorite"

#define rcar_api_user_commodity                     @"user/seller-commodity"
#define rcar_api_user_order                         @"user/order"
#define rcar_api_user_order_replies                 @"user/order-replies"

#define rcar_api_user_order_list                    @"user/order-list"
#define rcar_api_user_msg                           @"user/message"
#define rcar_api_user_msg_list                      @"user/message-list"



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

@end
