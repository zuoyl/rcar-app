//
//  UserListItemCell.h
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "UserModel.h"

@interface UserListItemCell : SWTableViewCell

- (void)setModel:(UserModel *)model;

@end
