//
//  UserListModel.h
//  CarSeller
//
//  Created by jenson.zuo on 15/8/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserListModel : APIResponseModel
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) NSArray *users;

@end
