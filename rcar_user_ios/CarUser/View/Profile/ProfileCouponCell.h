//
//  ProfileCouponCell.h
//  CarSeller
//
//  Created by jenson.zuo on 13/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

@interface ProfileCouponCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UILabel *startDateLabel;
@property (nonatomic, strong) IBOutlet UILabel *endDateLabel;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;

- (void) setModel:(CouponModel *)model;

@end
