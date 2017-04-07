//
//  UserInfoViewController.h
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JMStaticContentTableViewController.h"

@interface UserInfoViewController : JMStaticContentTableViewController

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) BOOL editMode;

@end
