//
//  GeneralTableViewCell.m
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "GeneralTableViewCell.h"

@implementation GeneralTableViewCell
@synthesize titleLabel;
@synthesize image;
@synthesize idxLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)icon title:(NSString *)title {
    self.titleLabel.text = title;
    self.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:icon]];
    self.image.frame = CGRectMake(15, 5, 35, 35);
    [self addSubview:self.image];
}

@end
