//
//  ProfileUserTitleCell.h
//  CarSeller
//
//  Created by jenson.zuo on 10/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileModel.h"

@interface ProfileUserTitleCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *carLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

- (void)setModel:(ProfileModel *)model;
@end
