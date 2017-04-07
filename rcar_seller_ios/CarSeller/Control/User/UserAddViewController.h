//
//  UserAddViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMStaticContentTableViewController.h"
#import "UserGroupModel.h"
#import "UserModel.h"

@protocol UserAddViewDelegate <NSObject>
@optional
- (void)userAddView:(UserModel *)user;
@end


@interface UserAddViewController : JMStaticContentTableViewController
@property (nonatomic, weak) UserGroupModel *groupModel;
@property (nonatomic, strong) id<UserAddViewDelegate> delegate;

@end
