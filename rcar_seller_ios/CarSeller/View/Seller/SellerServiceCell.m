//
//  ServiceOutlineCell.m
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerServiceCell.h"

@implementation SellerServiceCell {
    SellerServiceModel *_serviceModel;
}

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

- (void)setModel:(SellerServiceModel *)model {
    if (model == nil) return;
    
    self.textLabel.text = model.title;
    self.detailTextLabel.text = model.detail;
    _serviceModel = model;
    
    if (model.images.count > 0) {
        NSString *url = [[RCar imageServer] stringByAppendingString:model.images[0]];
        url = [url stringByAppendingString:@"?target=seller&size=32x32&thumbnail=yes"];
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"business_default"] options:SDWebImageOption];
    } else {
        // image view should be set by servide's type
        [self.imageView setImage:[UIImage imageNamed:@"business_default"]];
    }
}
@end
