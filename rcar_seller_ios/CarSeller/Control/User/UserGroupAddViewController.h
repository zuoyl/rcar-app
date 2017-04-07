//
//  UserGroupAddViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 24/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserGroupModel.h"


@protocol UserGroupAddViewDelegate <NSObject>
@optional
- (void)userGroupAddCompleted:(UserGroupModel *)group;

@end

@interface UserGroupAddViewController : UITableViewController
@property (nonatomic, strong) UserGroupModel *model;
@property (nonatomic, retain) id<UserGroupAddViewDelegate> delegate;
@end
