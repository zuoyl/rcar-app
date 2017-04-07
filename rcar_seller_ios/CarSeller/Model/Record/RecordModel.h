//
//  RecordModel.h
//  CarSeller
//
//  Created by jenson.zuo on 27/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject <NSCoding>
@property (nonatomic, strong) NSString *record_id;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *user;

@end
