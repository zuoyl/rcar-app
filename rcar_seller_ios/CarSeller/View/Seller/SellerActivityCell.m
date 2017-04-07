//
//  ActivityOutlineCell.m
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerActivityCell.h"

@implementation SellerActivityCell


- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SellerActivityModel *)model {
    self.textLabel.text = model.title;
    // check activities status
    if ([model.status isEqualToString:kActivityStatus_Doing])
        self.detailTextLabel.text = @"活动中";
    else if ([model.status isEqualToString:kActivityStatus_Completed])
        self.detailTextLabel.text = @"完成";
    else
        self.detailTextLabel.text = @"未知状态";
    
    // check wether image is loaded
    if (model.images == nil) {
        [self.imageView setImage:[UIImage imageNamed:@"business_default"]];
        return;
    }
    
    
    if (model.images.count > 0) {
        NSString *url = [[RCar imageServer] stringByAppendingString:model.images[0]];
        url = [url stringByAppendingString:@"?target=seller&size=32x32&thumbnail=yes"];
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"business_default"] options:SDWebImageOption];
    }
}

@end
