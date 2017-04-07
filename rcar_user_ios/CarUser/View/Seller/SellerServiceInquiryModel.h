//
//  SellerServiceInquiryModel.h
//  CarUser
//
//  Created by jenson.zuo on 18/5/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellerServiceInquiryModel : NSObject

@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *service_name;
@property (nonatomic, strong) NSString *seller_name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *distance;

@end
