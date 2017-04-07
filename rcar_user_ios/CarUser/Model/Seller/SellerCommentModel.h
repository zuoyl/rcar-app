//
//  SellerCommentModel.h
//  CarSeller
//
//  Created by jenson.zuo on 8/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellerCommentModel : NSObject
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *image_url;

@end
