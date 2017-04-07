//
//  ProfileCouponCell.m
//  CarSeller
//
//  Created by jenson.zuo on 13/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "ProfileCouponCell.h"
#import "UIImageView+WebCache.h"

@implementation ProfileCouponCell {
    UIActivityIndicatorView *_activity;
}

@synthesize titleLabel;
@synthesize contentLabel;
@synthesize startDateLabel;
@synthesize endDateLabel;
@synthesize statusLabel;
@synthesize backgroundImage;
@synthesize activity;

- (void)awakeFromNib {
    // Initialization code
    [self.activity stopAnimating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CouponModel *)model {
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.startDateLabel.text = model.start_date;
    self.endDateLabel.text = model.end_date;
    self.statusLabel.text = model.status;
    [_activity startAnimating];
    [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:[[RCar imageServer] stringByAppendingString:model.image]] placeholderImage:[UIImage imageNamed:@"adv_banner"] options:SDWebImageOption];
    
    
}

@end
