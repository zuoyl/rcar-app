//
//  CreditExchangeItemCell.m
//  CarSeller
//
//  Created by jenson.zuo on 13/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "CreditExchangeItemCell.h"

@implementation CreditExchangeItemCell
@synthesize imageView;
@synthesize titleLabel;
@synthesize contentLabel;
@synthesize startLabel;
@synthesize endLabel;
@synthesize statusLabel;
@synthesize countLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel: (CreditExchangeItemModel *)model {
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.statusLabel.text = model.status;
    self.startLabel.text = model.start_date;
    self.endLabel.text = model.end_date;
    
    __block CreditExchangeItemCell *_cell = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[RCar imageServer] stringByAppendingString:model.image]] placeholderImage:[UIImage imageNamed:@"adv_banner"] options:SDWebImageOption ];
    
}

@end
