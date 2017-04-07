//
//  UserListItemCell.m
//  CarSeller
//
//  Created by jenson.zuo on 23/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "UserListItemCell.h"

@implementation UserListItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(UserModel *)model {
    if (model.image == nil)
        self.imageView.image = [UIImage imageNamed:@"003"];
    else
        self.imageView.image = [UIImage imageNamed:model.image];
    self.textLabel.textColor = model.isVip ? [UIColor redColor] : [UIColor blackColor];
    self.textLabel.text = model.name;
//    self.detailTextLabel.text = model.intro;
}

@end
