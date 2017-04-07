//
//  ProfileUserTitleCell.m
//  CarSeller
//
//  Created by jenson.zuo on 10/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "ProfileUserTitleCell.h"

@implementation ProfileUserTitleCell

@synthesize nameLabel;
@synthesize carLabel;
@synthesize imageView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ProfileModel *)model {
    UserModel *userModel = [UserModel sharedClient];
    
    if ([userModel isLogin] == NO || model == nil) {
        self.nameLabel.text = @"未登录";
        self.carLabel.text = @"手机号";
        [self.imageView setImage:[UIImage imageNamed:@"airplane.png"]];
        
        return;
    }
    
    if (model.user_name == nil || [model.user_name isEqualToString:@""]) {
        self.nameLabel.text = @"车主";
    } else {
        self.nameLabel.text = model.user_name;
    }
    
    self.carLabel.text = userModel.user_id;
    
    if (model.image == nil || [model.image isEqualToString:@""]) {
        [self.imageView setImage:[UIImage imageNamed:@"airplane.png"]];
        return;
    }
    NSString *url = [[RCar imageServer] stringByAppendingString:model.image];
    url = [url stringByAppendingString:@"?target=user"];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"airplane.png"] options:SDWebImageOption ];
}

@end
