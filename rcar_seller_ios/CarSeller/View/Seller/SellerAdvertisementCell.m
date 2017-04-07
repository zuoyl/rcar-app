//
//  SellerAdvertisementCell.m
//  CarSeller
//
//  Created by jenson.zuo on 12/5/15.
//  Copyright (c) 2015 Cloud Stone Technology. All rights reserved.
//

#import "SellerAdvertisementCell.h"

@implementation SellerAdvertisementCell 

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

- (void)setModel:(AdvertisementModel *)model {
    self.textLabel.text = model.title;
    
    // check advertisement status
    if ([model.status isEqualToString:kAdvertisementStatus_New])
        self.detailTextLabel.text = @"新创建";
    else if ([model.status isEqualToString: kAdvertisementStatus_Wait])
        self.detailTextLabel.text = @"审核中";
    else if ([model.status isEqualToString:kAdvertisementStatus_Doing])
        self.detailTextLabel.text = @"投放中";
    else if ([model.status isEqualToString:kAdvertisementStatus_Completed])
        self.detailTextLabel.text = @"完成";
    else if ([model.status isEqualToString:kAdvertisementStatus_Canceling])
        self.detailTextLabel.text = @"撤销中";
    else
        self.detailTextLabel.text = @"未知状态";
    
    // check wether image is loaded
    if (model.images == nil || model.images.count == 0) {
        [self.imageView setImage:[UIImage imageNamed:@"business_default"]];
        return;
    } NSString *url = [[RCar imageServer] stringByAppendingString:model.images[0]];
    url = [url stringByAppendingString:@"?target=seller&size=32x32&thumbnail=yes"];
    
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"business_default"] options:SDWebImageOption ];
}


@end
