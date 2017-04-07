//
//  UserGroupModel.h
//  CarSeller
//
//  Created by jenson.zuo on 24/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserGroupItemModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *online;
@property (nonatomic, strong) NSString *image;
@end

@interface UserGroupModel : APIResponseModel <NSCoding>
@property (nonatomic, strong) NSString *group_id;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger online;
@property (nonatomic, assign) BOOL opened;

@end
