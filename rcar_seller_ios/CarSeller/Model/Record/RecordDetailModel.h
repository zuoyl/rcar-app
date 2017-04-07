//
//  RecordDetailModel.h
//  CarSeller
//
//  Created by jenson.zuo on 21/1/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIResponseModel.h"

@interface RecordDetailModel : APIResponseModel
@property (nonatomic, strong) NSString *record_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *items; // RecordItemModel
@end


@interface RecordItemModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSNumber *rate;
@end
